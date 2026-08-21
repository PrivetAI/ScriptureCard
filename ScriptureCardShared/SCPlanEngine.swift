import Foundation

/// Everything the plan system computes. Deliberately free of storage and of SwiftUI so the
/// widget process can use the same arithmetic the app shows.
enum SCPlanEngine {

    struct Status {
        let plan: SCPlan
        let policy: SCCatchUpPolicy
        /// The day the user should be reading today, 0-based. Equals `plan.length` when finished.
        let currentIndex: Int
        /// The day the calendar says they should be on under the strict policy, 0-based.
        let scheduledIndex: Int
        let completedCount: Int
        /// Day indices at or before the scheduled day that were never completed (strict only).
        let missedIndices: [Int]
        let isFinished: Bool
        let finishedKey: Int?
        let startKey: Int
        let todayKey: Int
        let todayComplete: Bool

        var total: Int { plan.length }

        var fraction: Double {
            guard total > 0 else { return 0 }
            return min(1.0, max(0.0, Double(completedCount) / Double(total)))
        }

        var percentText: String {
            "\(Int((fraction * 100).rounded()))%"
        }

        var daysBehind: Int { missedIndices.count }

        var remaining: Int { max(0, total - completedCount) }

        /// The day card to display. Clamped so it is always a valid index while the plan runs.
        var displayIndex: Int {
            if total == 0 { return 0 }
            return min(max(0, currentIndex), total - 1)
        }

        var headline: String {
            if isFinished { return "Completed" }
            if total == 0 { return "Empty plan" }
            return "Day \(displayIndex + 1) of \(total)"
        }

        var estimatedFinishKey: Int {
            guard total > 0 else { return todayKey }
            if let f = finishedKey { return f }
            switch policy {
            case .strict:
                return SCDateKey.adding(total - 1, to: startKey)
            case .flexible:
                return SCDateKey.adding(max(0, remaining - 1), to: todayKey)
            }
        }

        var scheduleNote: String {
            if isFinished, let f = finishedKey {
                return "Finished on " + SCDateKey.longString(f)
            }
            switch policy {
            case .strict:
                if daysBehind == 0 {
                    return "On schedule. Started " + SCDateKey.mediumString(startKey) + "."
                }
                return daysBehind == 1
                    ? "One day behind the schedule you set."
                    : "\(daysBehind) days behind the schedule you set."
            case .flexible:
                if completedCount == 0 {
                    return "Flexible pace. The plan waits until you read."
                }
                return "Flexible pace. \(remaining) " + (remaining == 1 ? "day" : "days") + " left whenever you are ready."
            }
        }
    }

    static func status(plan: SCPlan,
                       progress: SCPlanProgress,
                       policy: SCCatchUpPolicy,
                       todayKey: Int = SCDateKey.today) -> Status {
        let total = plan.length
        let firstIncomplete = progress.firstIncompleteIndex(total: total)
        let elapsed = SCDateKey.days(from: progress.startKey, to: todayKey)
        let scheduled = total == 0 ? 0 : min(max(0, elapsed), total - 1)

        var missed: [Int] = []
        if policy == .strict && total > 0 && progress.finishedKey == nil {
            var i = 0
            while i < min(scheduled, total) {
                if progress.completed[i] == nil { missed.append(i) }
                i += 1
            }
        }

        let current: Int
        if progress.finishedKey != nil {
            current = total
        } else {
            switch policy {
            case .flexible:
                current = firstIncomplete
            case .strict:
                // Show the scheduled day unless it is already read; then move to the next
                // unread day so the user always has something in front of them.
                if total == 0 {
                    current = 0
                } else if progress.completed[scheduled] == nil {
                    current = scheduled
                } else {
                    current = min(firstIncomplete, total - 1)
                }
            }
        }

        let displayed = total == 0 ? 0 : min(max(0, current), total - 1)
        let todayDone = progress.completed[displayed] != nil

        return Status(plan: plan,
                      policy: policy,
                      currentIndex: current,
                      scheduledIndex: scheduled,
                      completedCount: min(progress.completedCount, total),
                      missedIndices: missed,
                      isFinished: progress.finishedKey != nil,
                      finishedKey: progress.finishedKey,
                      startKey: progress.startKey,
                      todayKey: todayKey,
                      todayComplete: todayDone)
    }

    /// Under the strict policy, the calendar day a given plan day falls on.
    static func scheduledKey(for dayIndex: Int, progress: SCPlanProgress) -> Int {
        SCDateKey.adding(dayIndex, to: progress.startKey)
    }

    /// Re-pin the schedule so the first unread day lands on today, keeping every completed day.
    static func rebased(_ progress: SCPlanProgress, total: Int, todayKey: Int = SCDateKey.today) -> SCPlanProgress {
        var next = progress
        let firstIncomplete = progress.firstIncompleteIndex(total: total)
        next.startKey = SCDateKey.adding(-firstIncomplete, to: todayKey)
        next.lastTouchedKey = todayKey
        return next
    }
}
