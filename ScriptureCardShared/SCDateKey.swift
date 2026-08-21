import Foundation

/// All persisted dates are stored as an Int day key in the form yyyymmdd.
/// Comparing `Date` values directly never matches; the day key always does.
enum SCDateKey {

    static var calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "en_US_POSIX")
        cal.timeZone = TimeZone.current
        return cal
    }()

    static func key(from date: Date) -> Int {
        let c = calendar.dateComponents([.year, .month, .day], from: date)
        let y = c.year ?? 2000
        let m = c.month ?? 1
        let d = c.day ?? 1
        return y * 10000 + m * 100 + d
    }

    static var today: Int { key(from: Date()) }

    static func date(from key: Int) -> Date {
        var c = DateComponents()
        c.year = key / 10000
        c.month = (key / 100) % 100
        c.day = key % 100
        c.hour = 12
        return calendar.date(from: c) ?? Date()
    }

    static func adding(_ days: Int, to key: Int) -> Int {
        let base = calendar.startOfDay(for: date(from: key))
        guard let moved = calendar.date(byAdding: .day, value: days, to: base) else { return key }
        return self.key(from: moved)
    }

    /// Whole days from `a` to `b`. Negative when b precedes a.
    static func days(from a: Int, to b: Int) -> Int {
        let d1 = calendar.startOfDay(for: date(from: a))
        let d2 = calendar.startOfDay(for: date(from: b))
        let comps = calendar.dateComponents([.day], from: d1, to: d2)
        return comps.day ?? 0
    }

    static func startOfNextDay(after date: Date = Date()) -> Date {
        let start = calendar.startOfDay(for: date)
        return calendar.date(byAdding: .day, value: 1, to: start) ?? date.addingTimeInterval(86400)
    }

    // MARK: - Formatting (locale pinned so the UI never changes language)

    private static func formatter(_ format: String) -> DateFormatter {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.calendar = calendar
        f.timeZone = TimeZone.current
        f.dateFormat = format
        return f
    }

    private static let longFmt = formatter("MMMM d, yyyy")
    private static let mediumFmt = formatter("MMM d, yyyy")
    private static let weekdayFmt = formatter("EEE")
    private static let weekdayLongFmt = formatter("EEEE")
    private static let monthFmt = formatter("MMM")

    static func longString(_ key: Int) -> String { longFmt.string(from: date(from: key)) }
    static func mediumString(_ key: Int) -> String { mediumFmt.string(from: date(from: key)) }
    static func weekdayString(_ key: Int) -> String { weekdayFmt.string(from: date(from: key)) }
    static func weekdayLongString(_ key: Int) -> String { weekdayLongFmt.string(from: date(from: key)) }
    static func monthString(_ key: Int) -> String { monthFmt.string(from: date(from: key)) }

    static func monthIndex(_ key: Int) -> Int { (key / 100) % 100 }
    static func yearOf(_ key: Int) -> Int { key / 10000 }

    /// Day of the week as 0 = Sunday ... 6 = Saturday.
    static func weekdayIndex(_ key: Int) -> Int {
        let wd = calendar.component(.weekday, from: date(from: key))
        return max(0, min(6, wd - 1))
    }
}
