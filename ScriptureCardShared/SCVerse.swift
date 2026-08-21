import Foundation

// MARK: - Themes

enum SCTheme: String, CaseIterable, Codable {
    case hope
    case fear
    case provision
    case guidance
    case mercy
    case discipline
    case praise
    case doubt
    case endurance
    case love
    case humility
    case justice
    case rest
    case wisdom
    case thanksgiving

    var title: String {
        switch self {
        case .hope: return "Hope"
        case .fear: return "Fear"
        case .provision: return "Provision"
        case .guidance: return "Guidance"
        case .mercy: return "Mercy"
        case .discipline: return "Discipline"
        case .praise: return "Praise"
        case .doubt: return "Doubt"
        case .endurance: return "Endurance"
        case .love: return "Love"
        case .humility: return "Humility"
        case .justice: return "Justice"
        case .rest: return "Rest"
        case .wisdom: return "Wisdom"
        case .thanksgiving: return "Thanksgiving"
        }
    }

    var blurb: String {
        switch self {
        case .hope: return "Passages that look forward when the present is thin."
        case .fear: return "Words for the nights when the mind will not settle."
        case .provision: return "Daily bread, enough, and the hand that gives it."
        case .guidance: return "Direction for a fork in the road."
        case .mercy: return "Kindness offered before it is deserved."
        case .discipline: return "Correction understood as care, not rejection."
        case .praise: return "Language for gladness that outgrows small words."
        case .doubt: return "Honest questions kept inside the conversation."
        case .endurance: return "Staying, when staying is the hard thing."
        case .love: return "The steady kind, described plainly."
        case .humility: return "A right size for the self."
        case .justice: return "Fair weights, open hands, an even hearing."
        case .rest: return "Permission to stop."
        case .wisdom: return "Practical sense, gathered slowly."
        case .thanksgiving: return "Naming what was received."
        }
    }
}

// MARK: - Verse entry

struct SCVerse: Identifiable, Hashable {
    let id: String          // canonical reference, e.g. "John 3:16" or "Matthew 5:3-10"
    let book: String
    let chapter: Int
    let verse: Int
    let endVerse: Int
    let text: String
    let note: String
    let themes: [SCTheme]

    var reference: String { id }

    var shortReference: String {
        let abbr = SCBookOrder.abbreviation(for: book)
        if endVerse > verse { return "\(abbr) \(chapter):\(verse)-\(endVerse)" }
        return "\(abbr) \(chapter):\(verse)"
    }

    var wordCount: Int {
        text.split(whereSeparator: { $0 == " " || $0 == "\n" }).count
    }

    static func == (lhs: SCVerse, rhs: SCVerse) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

/// Compact constructor used by the authored verse tables.
func scv(_ book: String,
         _ chapter: Int,
         _ verse: Int,
         _ endVerse: Int,
         _ text: String,
         _ note: String,
         _ themes: [SCTheme]) -> SCVerse {
    let ref: String
    if endVerse > verse {
        ref = "\(book) \(chapter):\(verse)-\(endVerse)"
    } else {
        ref = "\(book) \(chapter):\(verse)"
    }
    return SCVerse(id: ref,
                   book: book,
                   chapter: chapter,
                   verse: verse,
                   endVerse: max(verse, endVerse),
                   text: text,
                   note: note,
                   themes: themes)
}

// MARK: - Canonical book order

enum SCBookOrder {
    static let all: [String] = [
        "Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy",
        "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel",
        "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra",
        "Nehemiah", "Esther", "Job", "Psalms", "Proverbs",
        "Ecclesiastes", "Song of Solomon", "Isaiah", "Jeremiah", "Lamentations",
        "Ezekiel", "Daniel", "Hosea", "Joel", "Amos",
        "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk",
        "Zephaniah", "Haggai", "Zechariah", "Malachi",
        "Matthew", "Mark", "Luke", "John", "Acts",
        "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians",
        "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians",
        "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews",
        "James", "1 Peter", "2 Peter", "1 John", "2 John",
        "3 John", "Jude", "Revelation"
    ]

    private static let indexMap: [String: Int] = {
        var map: [String: Int] = [:]
        for (i, name) in all.enumerated() { map[name] = i }
        return map
    }()

    static func index(of book: String) -> Int {
        indexMap[book] ?? 999
    }

    static func isOldTestament(_ book: String) -> Bool {
        index(of: book) < 39
    }

    private static let abbreviations: [String: String] = [
        "Genesis": "Gen", "Exodus": "Exod", "Leviticus": "Lev", "Numbers": "Num",
        "Deuteronomy": "Deut", "Joshua": "Josh", "Judges": "Judg", "Ruth": "Ruth",
        "1 Samuel": "1 Sam", "2 Samuel": "2 Sam", "1 Kings": "1 Kgs", "2 Kings": "2 Kgs",
        "1 Chronicles": "1 Chr", "2 Chronicles": "2 Chr", "Ezra": "Ezra",
        "Nehemiah": "Neh", "Esther": "Esth", "Job": "Job", "Psalms": "Ps",
        "Proverbs": "Prov", "Ecclesiastes": "Eccl", "Song of Solomon": "Song",
        "Isaiah": "Isa", "Jeremiah": "Jer", "Lamentations": "Lam", "Ezekiel": "Ezek",
        "Daniel": "Dan", "Hosea": "Hos", "Joel": "Joel", "Amos": "Amos",
        "Obadiah": "Obad", "Jonah": "Jonah", "Micah": "Mic", "Nahum": "Nah",
        "Habakkuk": "Hab", "Zephaniah": "Zeph", "Haggai": "Hag",
        "Zechariah": "Zech", "Malachi": "Mal", "Matthew": "Matt", "Mark": "Mark",
        "Luke": "Luke", "John": "John", "Acts": "Acts", "Romans": "Rom",
        "1 Corinthians": "1 Cor", "2 Corinthians": "2 Cor", "Galatians": "Gal",
        "Ephesians": "Eph", "Philippians": "Phil", "Colossians": "Col",
        "1 Thessalonians": "1 Thess", "2 Thessalonians": "2 Thess",
        "1 Timothy": "1 Tim", "2 Timothy": "2 Tim", "Titus": "Titus",
        "Philemon": "Phlm", "Hebrews": "Heb", "James": "Jas", "1 Peter": "1 Pet",
        "2 Peter": "2 Pet", "1 John": "1 John", "2 John": "2 John",
        "3 John": "3 John", "Jude": "Jude", "Revelation": "Rev"
    ]

    static func abbreviation(for book: String) -> String {
        abbreviations[book] ?? book
    }
}
