import Foundation

// MARK: - Plan model

struct SCPlanDay: Identifiable, Hashable {
    let index: Int          // assigned at load time, 0-based
    let title: String
    let refs: [String]
    let reflection: String

    var id: Int { index }
    var dayNumber: Int { index + 1 }
}

/// A day as authored, before indices are assigned.
struct SCPlanDaySeed {
    let title: String
    let refs: [String]
    let reflection: String
}

func scday(_ title: String, _ refs: [String], _ reflection: String) -> SCPlanDaySeed {
    SCPlanDaySeed(title: title, refs: refs, reflection: reflection)
}

struct SCPlan: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let theme: SCTheme
    let summary: String
    let days: [SCPlanDay]

    var length: Int { days.count }

    var lengthLabel: String {
        days.count == 1 ? "1 day" : "\(days.count) days"
    }

    /// Every distinct reference used by the plan, in order of first appearance.
    var allRefs: [String] {
        var seen = Set<String>()
        var out: [String] = []
        for day in days {
            for r in day.refs where !seen.contains(r) {
                seen.insert(r)
                out.append(r)
            }
        }
        return out
    }

    static func == (lhs: SCPlan, rhs: SCPlan) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

func scplan(_ id: String,
            _ title: String,
            _ subtitle: String,
            _ theme: SCTheme,
            _ summary: String,
            _ seeds: [SCPlanDaySeed]) -> SCPlan {
    var days: [SCPlanDay] = []
    days.reserveCapacity(seeds.count)
    for (i, s) in seeds.enumerated() {
        days.append(SCPlanDay(index: i, title: s.title, refs: s.refs, reflection: s.reflection))
    }
    return SCPlan(id: id, title: title, subtitle: subtitle, theme: theme, summary: summary, days: days)
}

// MARK: - Catch-up policy

enum SCCatchUpPolicy: String, Codable, CaseIterable {
    case strict
    case flexible

    var title: String {
        switch self {
        case .strict: return "Strict"
        case .flexible: return "Flexible"
        }
    }

    var explanation: String {
        switch self {
        case .strict:
            return "Day one is pinned to the date you started. If you skip a day it stays skipped, and the app tells you how far behind the schedule you are. You can rebase the schedule to today at any time without losing what you have already read."
        case .flexible:
            return "The plan waits for you. Day N only arrives once you have finished day N minus one, so a missed day simply makes the plan take longer. Nothing is ever marked as missed."
        }
    }
}
