import Foundation

// MARK: - Settings

enum SCWidgetContent: String, Codable, CaseIterable {
    case planVerse
    case verseOfDay
    case favourite

    var title: String {
        switch self {
        case .planVerse: return "Today's plan verse"
        case .verseOfDay: return "Verse of the day"
        case .favourite: return "A random favorite"
        }
    }

    var detail: String {
        switch self {
        case .planVerse: return "The first verse of the day you are on. Falls back to the verse of the day when no plan is active."
        case .verseOfDay: return "The same verse for everyone on a given date, chosen by the calendar rather than at random."
        case .favourite: return "One of your saved verses, rotating by date. Falls back to the verse of the day until you save one."
        }
    }
}

enum SCTextSize: String, Codable, CaseIterable {
    case compact
    case standard
    case large

    var title: String {
        switch self {
        case .compact: return "Compact"
        case .standard: return "Standard"
        case .large: return "Large"
        }
    }

    var scale: Double {
        switch self {
        case .compact: return 0.90
        case .standard: return 1.0
        case .large: return 1.18
        }
    }
}

struct SCSettings: Codable {
    var catchUp: SCCatchUpPolicy = .flexible
    var widgetContent: SCWidgetContent = .planVerse
    var textSize: SCTextSize = .standard
    var onboardingSeen: Bool = false
    var showEditorNotes: Bool = true
    var showOrnaments: Bool = true

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        catchUp = (try? c.decode(SCCatchUpPolicy.self, forKey: .catchUp)) ?? .flexible
        widgetContent = (try? c.decode(SCWidgetContent.self, forKey: .widgetContent)) ?? .planVerse
        textSize = (try? c.decode(SCTextSize.self, forKey: .textSize)) ?? .standard
        onboardingSeen = (try? c.decode(Bool.self, forKey: .onboardingSeen)) ?? false
        showEditorNotes = (try? c.decode(Bool.self, forKey: .showEditorNotes)) ?? true
        showOrnaments = (try? c.decode(Bool.self, forKey: .showOrnaments)) ?? true
    }

    enum CodingKeys: String, CodingKey {
        case catchUp, widgetContent, textSize, onboardingSeen, showEditorNotes, showOrnaments
    }
}

// MARK: - Plan progress

struct SCPlanProgress: Codable, Identifiable {
    var planID: String = ""
    /// Calendar day on which day 1 is scheduled (strict policy).
    var startKey: Int = 0
    /// dayIndex -> day key on which it was marked read.
    var completed: [Int: Int] = [:]
    /// Set when the last day is finished.
    var finishedKey: Int? = nil
    /// Most recent activity, for ordering the Today tab.
    var lastTouchedKey: Int = 0

    var id: String { planID }

    init(planID: String, startKey: Int) {
        self.planID = planID
        self.startKey = startKey
        self.lastTouchedKey = startKey
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        planID = (try? c.decode(String.self, forKey: .planID)) ?? ""
        startKey = (try? c.decode(Int.self, forKey: .startKey)) ?? SCDateKey.today
        let pairs = (try? c.decode([String: Int].self, forKey: .completed)) ?? [:]
        var rebuilt: [Int: Int] = [:]
        for (k, v) in pairs {
            if let i = Int(k) { rebuilt[i] = v }
        }
        completed = rebuilt
        finishedKey = try? c.decode(Int.self, forKey: .finishedKey)
        lastTouchedKey = (try? c.decode(Int.self, forKey: .lastTouchedKey)) ?? startKey
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(planID, forKey: .planID)
        try c.encode(startKey, forKey: .startKey)
        var pairs: [String: Int] = [:]
        for (k, v) in completed { pairs[String(k)] = v }
        try c.encode(pairs, forKey: .completed)
        try c.encodeIfPresent(finishedKey, forKey: .finishedKey)
        try c.encode(lastTouchedKey, forKey: .lastTouchedKey)
    }

    enum CodingKeys: String, CodingKey {
        case planID, startKey, completed, finishedKey, lastTouchedKey
    }

    var completedCount: Int { completed.count }

    var isFinished: Bool { finishedKey != nil }

    /// Lowest day index not yet completed, or `total` when everything is done.
    func firstIncompleteIndex(total: Int) -> Int {
        var i = 0
        while i < total {
            if completed[i] == nil { return i }
            i += 1
        }
        return total
    }
}

// MARK: - Completed runs

struct SCCompletedRun: Codable, Identifiable {
    var runID: String = UUID().uuidString
    var planID: String = ""
    var startKey: Int = 0
    var finishedKey: Int = 0
    var dayCount: Int = 0
    var elapsedDays: Int = 0

    var id: String { runID }

    init(planID: String, startKey: Int, finishedKey: Int, dayCount: Int) {
        self.planID = planID
        self.startKey = startKey
        self.finishedKey = finishedKey
        self.dayCount = dayCount
        self.elapsedDays = max(1, SCDateKey.days(from: startKey, to: finishedKey) + 1)
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        runID = (try? c.decode(String.self, forKey: .runID)) ?? UUID().uuidString
        planID = (try? c.decode(String.self, forKey: .planID)) ?? ""
        startKey = (try? c.decode(Int.self, forKey: .startKey)) ?? 0
        finishedKey = (try? c.decode(Int.self, forKey: .finishedKey)) ?? 0
        dayCount = (try? c.decode(Int.self, forKey: .dayCount)) ?? 0
        elapsedDays = (try? c.decode(Int.self, forKey: .elapsedDays)) ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case runID, planID, startKey, finishedKey, dayCount, elapsedDays
    }
}

// MARK: - Journal

struct SCJournalEntry: Codable, Identifiable {
    var dayKey: Int = 0
    var text: String = ""
    var planID: String? = nil
    var dayIndex: Int? = nil

    var id: Int { dayKey }

    init(dayKey: Int, text: String, planID: String?, dayIndex: Int?) {
        self.dayKey = dayKey
        self.text = text
        self.planID = planID
        self.dayIndex = dayIndex
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        dayKey = (try? c.decode(Int.self, forKey: .dayKey)) ?? 0
        text = (try? c.decode(String.self, forKey: .text)) ?? ""
        planID = try? c.decode(String.self, forKey: .planID)
        dayIndex = try? c.decode(Int.self, forKey: .dayIndex)
    }

    enum CodingKeys: String, CodingKey {
        case dayKey, text, planID, dayIndex
    }
}

// MARK: - Daily reading record

struct SCDayRecord: Codable {
    var dayKey: Int = 0
    var versesRead: Int = 0
    var planDaysRead: Int = 0
    var soloRead: Bool = false

    init(dayKey: Int) { self.dayKey = dayKey }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        dayKey = (try? c.decode(Int.self, forKey: .dayKey)) ?? 0
        versesRead = (try? c.decode(Int.self, forKey: .versesRead)) ?? 0
        planDaysRead = (try? c.decode(Int.self, forKey: .planDaysRead)) ?? 0
        soloRead = (try? c.decode(Bool.self, forKey: .soloRead)) ?? false
    }

    enum CodingKeys: String, CodingKey {
        case dayKey, versesRead, planDaysRead, soloRead
    }

    var isActive: Bool { versesRead > 0 || planDaysRead > 0 || soloRead }
}

// MARK: - Root persisted state

struct SCPersistedState: Codable {
    var schemaVersion: Int = 1
    var settings: SCSettings = SCSettings()
    var progress: [SCPlanProgress] = []
    var completedRuns: [SCCompletedRun] = []
    var journal: [SCJournalEntry] = []
    var favourites: [String] = []
    var records: [SCDayRecord] = []
    var bookTally: [String: Int] = [:]
    var firstLaunchKey: Int = SCDateKey.today

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        schemaVersion = (try? c.decode(Int.self, forKey: .schemaVersion)) ?? 1
        settings = (try? c.decode(SCSettings.self, forKey: .settings)) ?? SCSettings()
        progress = (try? c.decode([SCPlanProgress].self, forKey: .progress)) ?? []
        completedRuns = (try? c.decode([SCCompletedRun].self, forKey: .completedRuns)) ?? []
        journal = (try? c.decode([SCJournalEntry].self, forKey: .journal)) ?? []
        favourites = (try? c.decode([String].self, forKey: .favourites)) ?? []
        records = (try? c.decode([SCDayRecord].self, forKey: .records)) ?? []
        bookTally = (try? c.decode([String: Int].self, forKey: .bookTally)) ?? [:]
        firstLaunchKey = (try? c.decode(Int.self, forKey: .firstLaunchKey)) ?? SCDateKey.today
    }

    enum CodingKeys: String, CodingKey {
        case schemaVersion, settings, progress, completedRuns, journal, favourites, records, bookTally, firstLaunchKey
    }
}
