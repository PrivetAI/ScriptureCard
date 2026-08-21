import Foundation

/// Joins the authored plan tables into one list, dropping any duplicate id and any plan
/// that somehow ended up with no days.
enum SCPlanLibrary {

    static let plans: [SCPlan] = {
        var merged: [SCPlan] = []
        merged.append(contentsOf: SCPlanTableA.plans)
        merged.append(contentsOf: SCPlanTableB.plans)
        merged.append(contentsOf: SCPlanTableC.plans)
        merged.append(contentsOf: SCPlanTableD.plans)

        var seen = Set<String>()
        var out: [SCPlan] = []
        for p in merged where !seen.contains(p.id) && !p.days.isEmpty {
            seen.insert(p.id)
            out.append(p)
        }
        return out
    }()

    /// Plan groupings offered on the Plans tab.
    enum Shelf: Int, CaseIterable {
        case short
        case month
        case season
        case all

        /// Kept short on purpose: four cells share the width of a 375 pt screen, and the
        /// fuller wording truncated there even at the segmented control's scale factor.
        var title: String {
            switch self {
            case .short: return "1 week"
            case .month: return "2-3 weeks"
            case .season: return "A season"
            case .all: return "All"
            }
        }

        var caption: String {
            switch self {
            case .short: return "Seven to ten days."
            case .month: return "Eleven to twenty-one days."
            case .season: return "Twenty-two days and longer."
            case .all: return "Every plan in the app."
            }
        }

        func matches(_ plan: SCPlan) -> Bool {
            switch self {
            case .short: return plan.length <= 10
            case .month: return plan.length > 10 && plan.length <= 21
            case .season: return plan.length > 21
            case .all: return true
            }
        }
    }
}
