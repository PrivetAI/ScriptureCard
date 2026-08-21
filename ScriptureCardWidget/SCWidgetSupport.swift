import SwiftUI
import WidgetKit

// MARK: - Container background (required from iOS 17 onward)

extension View {
    @ViewBuilder
    func scWidgetContainerBackground<S: ShapeStyle>(_ style: S) -> some View {
        if #available(iOS 17.0, *) {
            self.containerBackground(style, for: .widget)
        } else {
            self.background(style)
        }
    }
}

// MARK: - Palette for the home-screen families

enum SCWidgetPalette {
    static let parchment = Color(red: 0.965, green: 0.945, blue: 0.906)
    static let card      = Color(red: 0.996, green: 0.988, blue: 0.965)
    static let ink       = Color(red: 0.106, green: 0.157, blue: 0.224)
    static let inkSoft   = Color(red: 0.325, green: 0.376, blue: 0.443)
    static let inkFaint  = Color(red: 0.573, green: 0.612, blue: 0.667)
    static let gold      = Color(red: 0.722, green: 0.537, blue: 0.169)
    static let rule      = Color(red: 0.847, green: 0.812, blue: 0.741)
    static let sage      = Color(red: 0.365, green: 0.478, blue: 0.416)
}

// MARK: - Text fitting

enum SCWidgetText {

    /// Trim to at most `limit` characters, cutting at a word boundary and adding an ellipsis.
    /// Never returns an empty string for a non-empty input.
    static func fit(_ text: String, limit: Int) -> String {
        let cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard limit > 4 else { return cleaned }
        if cleaned.count <= limit { return cleaned }

        let head = String(cleaned.prefix(limit))
        if let space = head.lastIndex(of: " ") {
            var cut = String(head[head.startIndex..<space])
            while let last = cut.last, last == "," || last == ";" || last == ":" || last == "." || last == " " {
                cut.removeLast()
            }
            if cut.count >= 8 { return cut + "\u{2026}" }
        }
        return head + "\u{2026}"
    }
}

// MARK: - Timeline entry

struct SCWidgetEntry: TimelineEntry {
    let date: Date
    let dayKey: Int
    let verse: SCVerse
    let planTitle: String?
    let planDay: Int
    let planTotal: Int
    let planRead: Bool

    var hasPlan: Bool { planTitle != nil && planTotal > 0 }

    var planFraction: Double {
        guard planTotal > 0 else { return 0 }
        let done = planRead ? planDay : max(0, planDay - 1)
        return min(1.0, max(0.0, Double(done) / Double(planTotal)))
    }
}

// MARK: - Shared entry construction

enum SCWidgetBuilder {

    static let content = SCContent.shared

    /// Resolves the verse for one calendar day. Falls back all the way down to the
    /// deterministic verse of the day, so a missing App Group never yields an empty widget.
    static func verse(for dayKey: Int,
                      offset: Int,
                      snapshot: SCWidgetSnapshot?,
                      preferShort: Bool) -> SCVerse {
        let fallback = preferShort ? content.shortVerseOfDay(for: dayKey) : content.verseOfDay(for: dayKey)
        guard let snap = snapshot else { return fallback }

        switch snap.mode {
        case .verseOfDay:
            return fallback
        case .planVerse:
            if offset == 0, let ref = snap.planVerseRef, let v = content.verse(ref: ref) {
                return v
            }
            return fallback
        case .favourite:
            let refs = snap.favouriteRefs.compactMap { content.verse(ref: $0) }
            guard !refs.isEmpty else { return fallback }
            let ordinal = SCContent.ordinalDay(dayKey)
            let idx = ((ordinal % refs.count) + refs.count) % refs.count
            return refs[idx]
        }
    }

    /// Seven daily entries, each stamped at local midnight. The plan figures are recomputed
    /// for each entry's own date: carrying today's day number and a forced "not yet read"
    /// into tomorrow made the ring run backwards overnight without the user touching anything.
    static func timeline(preferShort: Bool) -> [SCWidgetEntry] {
        let snapshot = SCSharedBridge.read()
        let now = Date()
        let todayKey = SCDateKey.today
        var entries: [SCWidgetEntry] = []

        let plan: SCPlan? = snapshot?.planID.flatMap { content.plan(id: $0) }
        let progress = snapshot?.planProgress

        var offset = 0
        while offset < 7 {
            let dayKey = SCDateKey.adding(offset, to: todayKey)
            let date: Date
            if offset == 0 {
                date = now
            } else {
                date = SCDateKey.calendar.startOfDay(for: SCDateKey.date(from: dayKey))
            }
            let v = verse(for: dayKey, offset: offset, snapshot: snapshot, preferShort: preferShort)

            var planDay = snapshot?.planDayNumber ?? 0
            var planTotal = snapshot?.planDayTotal ?? 0
            var planRead = offset == 0 ? (snapshot?.planDayRead ?? false) : false
            if let plan = plan, let progress = progress {
                let status = SCPlanEngine.status(plan: plan,
                                                 progress: progress,
                                                 policy: snapshot?.catchUp ?? .flexible,
                                                 todayKey: dayKey)
                planDay = status.displayIndex + 1
                planTotal = status.total
                planRead = status.todayComplete
            }

            entries.append(SCWidgetEntry(date: date,
                                         dayKey: dayKey,
                                         verse: v,
                                         planTitle: snapshot?.planTitle,
                                         planDay: planDay,
                                         planTotal: planTotal,
                                         planRead: planRead))
            offset += 1
        }
        return entries
    }

    static var nextReload: Date {
        SCDateKey.startOfNextDay()
    }

    static func placeholder(preferShort: Bool) -> SCWidgetEntry {
        let todayKey = SCDateKey.today
        let v = preferShort ? content.shortVerseOfDay(for: todayKey) : content.verseOfDay(for: todayKey)
        return SCWidgetEntry(date: Date(),
                             dayKey: todayKey,
                             verse: v,
                             planTitle: nil,
                             planDay: 0,
                             planTotal: 0,
                             planRead: false)
    }
}

// MARK: - Drawn pieces reused by the widget views

struct SCWidgetRing: View {
    var fraction: Double
    var lineWidth: CGFloat = 4
    var track: Color
    var tint: Color

    var body: some View {
        Canvas { ctx, size in
            let inset = lineWidth / 2
            let rect = CGRect(x: inset, y: inset,
                              width: max(1, size.width - lineWidth),
                              height: max(1, size.height - lineWidth))
            ctx.stroke(Path(ellipseIn: rect), with: .color(track), lineWidth: lineWidth)
            let f = min(1, max(0, fraction))
            if f > 0.001 {
                var arc = Path()
                arc.addArc(center: CGPoint(x: size.width / 2, y: size.height / 2),
                           radius: max(1, (min(size.width, size.height) - lineWidth) / 2),
                           startAngle: .degrees(-90),
                           endAngle: .degrees(-90 + 360 * f),
                           clockwise: false)
                ctx.stroke(arc, with: .color(tint),
                           style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            }
        }
    }
}

struct SCWidgetRule: View {
    var color: Color

    var body: some View {
        Canvas { ctx, size in
            let midY = size.height / 2
            let gap = min(12.0, size.width * 0.14)
            var left = Path()
            left.move(to: CGPoint(x: 0, y: midY))
            left.addLine(to: CGPoint(x: size.width / 2 - gap, y: midY))
            var right = Path()
            right.move(to: CGPoint(x: size.width / 2 + gap, y: midY))
            right.addLine(to: CGPoint(x: size.width, y: midY))
            ctx.stroke(left, with: .color(color), lineWidth: 0.8)
            ctx.stroke(right, with: .color(color), lineWidth: 0.8)
            var dia = Path()
            let r = min(3.0, size.height / 2)
            dia.move(to: CGPoint(x: size.width / 2, y: midY - r))
            dia.addLine(to: CGPoint(x: size.width / 2 + r, y: midY))
            dia.addLine(to: CGPoint(x: size.width / 2, y: midY + r))
            dia.addLine(to: CGPoint(x: size.width / 2 - r, y: midY))
            dia.closeSubpath()
            ctx.fill(dia, with: .color(color))
        }
        .frame(height: 8)
    }
}
