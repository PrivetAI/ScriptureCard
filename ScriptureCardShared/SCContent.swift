import Foundation

/// The authored library: every verse entry, every plan, and the lookups built over them.
/// Both the app target and the widget extension compile and use this type.
final class SCContent {

    static let shared = SCContent()

    let verses: [SCVerse]
    let plans: [SCPlan]

    private let byRef: [String: SCVerse]
    private let byBookMap: [String: [SCVerse]]
    private let byThemeMap: [SCTheme: [SCVerse]]
    private let plansByID: [String: SCPlan]
    private let plansUsingRef: [String: [String]]
    /// Deterministic rotation used by the verse of the day, shuffled once by a fixed seed
    /// so that consecutive days are not adjacent references.
    private let rotation: [SCVerse]
    /// Every searchable field lowercased once at startup. Doing it inside `search` meant
    /// roughly 2,500 fresh string allocations on every keystroke.
    private let searchRows: [SearchRow]

    private struct SearchRow {
        let id: String
        let shortReference: String
        let text: String
        let note: String
    }

    private init() {
        var merged: [SCVerse] = []
        merged.append(contentsOf: SCVerseTableA.entries)
        merged.append(contentsOf: SCVerseTableB.entries)
        merged.append(contentsOf: SCVerseTableC.entries)
        merged.append(contentsOf: SCVerseTableD.entries)
        merged.append(contentsOf: SCVerseTableE.entries)

        // De-duplicate on reference, keeping the first occurrence.
        var seen = Set<String>()
        var unique: [SCVerse] = []
        unique.reserveCapacity(merged.count)
        for v in merged where !seen.contains(v.id) {
            seen.insert(v.id)
            unique.append(v)
        }
        unique.sort { a, b in
            let ba = SCBookOrder.index(of: a.book)
            let bb = SCBookOrder.index(of: b.book)
            if ba != bb { return ba < bb }
            if a.chapter != b.chapter { return a.chapter < b.chapter }
            return a.verse < b.verse
        }
        verses = unique
        searchRows = unique.map {
            SearchRow(id: $0.id.lowercased(),
                      shortReference: $0.shortReference.lowercased(),
                      text: $0.text.lowercased(),
                      note: $0.note.lowercased())
        }

        var refMap: [String: SCVerse] = [:]
        var bookMap: [String: [SCVerse]] = [:]
        var themeMap: [SCTheme: [SCVerse]] = [:]
        for v in unique {
            refMap[v.id] = v
            bookMap[v.book, default: []].append(v)
            for t in v.themes { themeMap[t, default: []].append(v) }
        }
        byRef = refMap
        byBookMap = bookMap
        byThemeMap = themeMap

        let authored = SCPlanLibrary.plans
        plans = authored
        var pMap: [String: SCPlan] = [:]
        var usage: [String: [String]] = [:]
        for p in authored {
            pMap[p.id] = p
            for r in p.allRefs {
                usage[r, default: []].append(p.id)
            }
        }
        plansByID = pMap
        plansUsingRef = usage

        // A fixed linear-congruential shuffle: identical on every device and every launch,
        // which is what makes the widget and the app agree on the verse of the day.
        var pool = unique
        var seed: UInt64 = 0x5C71_9721
        var i = pool.count - 1
        while i > 0 {
            seed = seed &* 6364136223846793005 &+ 1442695040888963407
            let j = Int((seed >> 33) % UInt64(i + 1))
            pool.swapAt(i, j)
            i -= 1
        }
        rotation = pool
    }

    // MARK: - Lookups

    var verseCount: Int { verses.count }
    var planCount: Int { plans.count }

    var books: [String] {
        byBookMap.keys.sorted { SCBookOrder.index(of: $0) < SCBookOrder.index(of: $1) }
    }

    func verse(ref: String) -> SCVerse? { byRef[ref] }

    func verses(inBook book: String) -> [SCVerse] {
        (byBookMap[book] ?? []).sorted { a, b in
            if a.chapter != b.chapter { return a.chapter < b.chapter }
            return a.verse < b.verse
        }
    }

    func verses(theme: SCTheme) -> [SCVerse] {
        (byThemeMap[theme] ?? []).sorted { a, b in
            let ba = SCBookOrder.index(of: a.book)
            let bb = SCBookOrder.index(of: b.book)
            if ba != bb { return ba < bb }
            if a.chapter != b.chapter { return a.chapter < b.chapter }
            return a.verse < b.verse
        }
    }

    func count(theme: SCTheme) -> Int { byThemeMap[theme]?.count ?? 0 }

    func plan(id: String) -> SCPlan? { plansByID[id] }

    func plansUsing(ref: String) -> [SCPlan] {
        (plansUsingRef[ref] ?? []).compactMap { plansByID[$0] }
    }

    /// Verses for one plan day. Never returns an empty array: if a reference cannot be
    /// resolved the plan's theme supplies a stand-in so no screen can render blank.
    func verses(for day: SCPlanDay, in plan: SCPlan) -> [SCVerse] {
        var out: [SCVerse] = []
        for r in day.refs {
            if let v = byRef[r] { out.append(v) }
        }
        if out.isEmpty {
            let pool = byThemeMap[plan.theme] ?? verses
            if pool.isEmpty { return [] }
            // A stable hand-rolled hash: Swift's hashValue is seeded per process, and this
            // stand-in must pick the same verse on every launch.
            var h = 2166136261
            for byte in plan.id.utf8 {
                h = (h ^ Int(byte)) &* 16777619
                h &= 0x7FFF_FFFF
            }
            let idx = ((h &+ day.index) % pool.count + pool.count) % pool.count
            out.append(pool[idx])
        }
        return out
    }

    func verseCount(for plan: SCPlan) -> Int {
        var total = 0
        for d in plan.days { total += max(1, d.refs.count) }
        return total
    }

    // MARK: - Search

    func search(_ raw: String, limit: Int = 120) -> [SCVerse] {
        let q = raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard q.count >= 2 else { return [] }
        var refHits: [SCVerse] = []
        var textHits: [SCVerse] = []
        for (i, row) in searchRows.enumerated() {
            if row.id.contains(q) || row.shortReference.contains(q) {
                refHits.append(verses[i])
            } else if row.text.contains(q) || row.note.contains(q) {
                textHits.append(verses[i])
            }
            if refHits.count + textHits.count >= limit { break }
        }
        return refHits + textHits
    }

    // MARK: - Verse of the day

    /// Deterministic by calendar date. The widget and the app call the same function so they
    /// can never disagree, and there is no stored state involved.
    func verseOfDay(for dayKey: Int) -> SCVerse {
        guard !rotation.isEmpty else {
            return SCVerse(id: "Psalms 23:1", book: "Psalms", chapter: 23, verse: 1, endVerse: 1,
                           text: "The LORD is my shepherd; I shall not want.",
                           note: "The whole psalm rests on this first clause.",
                           themes: [.provision, .rest])
        }
        let ordinal = SCContent.ordinalDay(dayKey)
        let idx = ((ordinal % rotation.count) + rotation.count) % rotation.count
        return rotation[idx]
    }

    /// Days since 2000-01-01, computed from the key arithmetic only so it never depends on
    /// the device time zone drifting between the app and the widget process.
    static func ordinalDay(_ dayKey: Int) -> Int {
        let y = dayKey / 10000
        let m = (dayKey / 100) % 100
        let d = dayKey % 100
        // Howard Hinnant's days-from-civil algorithm.
        let yy = m <= 2 ? y - 1 : y
        let era = (yy >= 0 ? yy : yy - 399) / 400
        let yoe = yy - era * 400
        let mp = (m + 9) % 12
        let doy = (153 * mp + 2) / 5 + d - 1
        let doe = yoe * 365 + yoe / 4 - yoe / 100 + doy
        return era * 146097 + doe - 719468
    }

    /// A short verse suitable for the tightest widget family.
    func shortVerseOfDay(for dayKey: Int) -> SCVerse {
        let primary = verseOfDay(for: dayKey)
        if primary.text.count <= 150 { return primary }
        // Walk forward through the rotation for the first compact one, bounded so it always ends.
        guard !rotation.isEmpty else { return primary }
        let ordinal = SCContent.ordinalDay(dayKey)
        var step = 1
        while step <= 40 {
            let idx = (((ordinal + step) % rotation.count) + rotation.count) % rotation.count
            let candidate = rotation[idx]
            if candidate.text.count <= 150 { return candidate }
            step += 1
        }
        return primary
    }
}
