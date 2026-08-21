import Foundation

/// The small payload the app hands to the widget through the App Group.
/// Every field is optional at decode time: if the group is not provisioned the widget still
/// renders a complete card from the deterministic verse of the day.
struct SCWidgetSnapshot: Codable {
    var writtenKey: Int = 0
    var mode: SCWidgetContent = .planVerse
    var planID: String? = nil
    var planTitle: String? = nil
    var planDayNumber: Int = 0
    var planDayTotal: Int = 0
    var planDayRead: Bool = false
    var planVerseRef: String? = nil
    var favouriteRefs: [String] = []
    var streak: Int = 0
    /// The plan's own record, so the widget can recompute the day number and the read state
    /// for a future timeline entry instead of freezing today's figures on every one of them.
    var planProgress: SCPlanProgress? = nil
    var catchUp: SCCatchUpPolicy = .flexible

    init() {}

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        writtenKey = (try? c.decode(Int.self, forKey: .writtenKey)) ?? 0
        mode = (try? c.decode(SCWidgetContent.self, forKey: .mode)) ?? .planVerse
        planID = try? c.decode(String.self, forKey: .planID)
        planTitle = try? c.decode(String.self, forKey: .planTitle)
        planDayNumber = (try? c.decode(Int.self, forKey: .planDayNumber)) ?? 0
        planDayTotal = (try? c.decode(Int.self, forKey: .planDayTotal)) ?? 0
        planDayRead = (try? c.decode(Bool.self, forKey: .planDayRead)) ?? false
        planVerseRef = try? c.decode(String.self, forKey: .planVerseRef)
        favouriteRefs = (try? c.decode([String].self, forKey: .favouriteRefs)) ?? []
        streak = (try? c.decode(Int.self, forKey: .streak)) ?? 0
        planProgress = try? c.decode(SCPlanProgress.self, forKey: .planProgress)
        catchUp = (try? c.decode(SCCatchUpPolicy.self, forKey: .catchUp)) ?? .flexible
    }

    enum CodingKeys: String, CodingKey {
        case writtenKey, mode, planID, planTitle, planDayNumber, planDayTotal
        case planDayRead, planVerseRef, favouriteRefs, streak, planProgress, catchUp
    }

    var hasPlan: Bool {
        planID != nil && planDayTotal > 0
    }
}

enum SCSharedBridge {

    static let groupName = "group.com.scripturecard.app"
    private static let snapshotKey = "sc.widget.snapshot.v1"

    private static var suite: UserDefaults? {
        UserDefaults(suiteName: groupName)
    }

    static func write(_ snapshot: SCWidgetSnapshot) {
        guard let defaults = suite else { return }
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(snapshot) {
            defaults.set(data, forKey: snapshotKey)
        }
    }

    /// Returns nil whenever the App Group is unavailable or has never been written.
    /// Callers must have a full, attractive fallback for that case.
    static func read() -> SCWidgetSnapshot? {
        guard let defaults = suite,
              let data = defaults.data(forKey: snapshotKey) else { return nil }
        return try? JSONDecoder().decode(SCWidgetSnapshot.self, from: data)
    }
}
