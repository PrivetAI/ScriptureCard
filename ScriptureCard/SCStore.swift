import Foundation
import SwiftUI
import WidgetKit

/// Single source of truth for everything the user has done. Persists to UserDefaults as one
/// JSON blob and republishes the widget snapshot after every mutation.
final class SCStore: ObservableObject {

    private static let storageKey = "sc.state.v1"

    @Published private(set) var state: SCPersistedState

    private let content = SCContent.shared

    init() {
        if let data = UserDefaults.standard.data(forKey: SCStore.storageKey),
           let decoded = try? JSONDecoder().decode(SCPersistedState.self, from: data) {
            state = decoded
        } else {
            var fresh = SCPersistedState()
            fresh.firstLaunchKey = SCDateKey.today
            state = fresh
        }
        publishSnapshot()
    }

    // MARK: - Persistence

    private func save() {
        if let data = try? JSONEncoder().encode(state) {
            UserDefaults.standard.set(data, forKey: SCStore.storageKey)
        }
        publishSnapshot()
    }

    private func publishSnapshot() {
        var snap = SCWidgetSnapshot()
        snap.writtenKey = SCDateKey.today
        snap.mode = state.settings.widgetContent
        snap.favouriteRefs = state.favourites
        snap.streak = currentStreak
        snap.catchUp = state.settings.catchUp

        if let focus = focusPlan() {
            let st = SCPlanEngine.status(plan: focus.plan, progress: focus.progress, policy: state.settings.catchUp)
            snap.planID = focus.plan.id
            snap.planTitle = focus.plan.title
            snap.planDayNumber = st.displayIndex + 1
            snap.planDayTotal = st.total
            snap.planDayRead = st.todayComplete
            snap.planProgress = focus.progress
            let day = focus.plan.days[st.displayIndex]
            snap.planVerseRef = content.verses(for: day, in: focus.plan).first?.id
        }
        SCSharedBridge.write(snap)
        WidgetCenter.shared.reloadAllTimelines()
    }

    // MARK: - Settings

    var settings: SCSettings { state.settings }

    func setCatchUp(_ policy: SCCatchUpPolicy) {
        state.settings.catchUp = policy
        save()
    }

    func setWidgetContent(_ mode: SCWidgetContent) {
        state.settings.widgetContent = mode
        save()
    }

    func setTextSize(_ size: SCTextSize) {
        state.settings.textSize = size
        save()
    }

    func setShowEditorNotes(_ on: Bool) {
        state.settings.showEditorNotes = on
        save()
    }

    func setShowOrnaments(_ on: Bool) {
        state.settings.showOrnaments = on
        save()
    }

    func markOnboardingSeen() {
        guard !state.settings.onboardingSeen else { return }
        state.settings.onboardingSeen = true
        save()
    }

    func replayOnboarding() {
        state.settings.onboardingSeen = false
        save()
    }

    // MARK: - Plan progress

    func progress(for planID: String) -> SCPlanProgress? {
        state.progress.first { $0.planID == planID }
    }

    func isStarted(_ planID: String) -> Bool {
        progress(for: planID) != nil
    }

    var activeProgress: [SCPlanProgress] {
        state.progress
            .filter { $0.finishedKey == nil }
            .sorted { $0.lastTouchedKey > $1.lastTouchedKey }
    }

    var finishedProgress: [SCPlanProgress] {
        state.progress
            .filter { $0.finishedKey != nil }
            .sorted { ($0.finishedKey ?? 0) > ($1.finishedKey ?? 0) }
    }

    func status(for plan: SCPlan) -> SCPlanEngine.Status? {
        guard let p = progress(for: plan.id) else { return nil }
        return SCPlanEngine.status(plan: plan, progress: p, policy: state.settings.catchUp)
    }

    /// The plan the Today tab leads with: the most recently touched unfinished plan.
    func focusPlan() -> (plan: SCPlan, progress: SCPlanProgress)? {
        for p in activeProgress {
            if let plan = content.plan(id: p.planID) { return (plan, p) }
        }
        return nil
    }

    func startPlan(_ plan: SCPlan) {
        if let idx = state.progress.firstIndex(where: { $0.planID == plan.id }) {
            // Already there: just bring it forward.
            state.progress[idx].lastTouchedKey = SCDateKey.today
        } else {
            var fresh = SCPlanProgress(planID: plan.id, startKey: SCDateKey.today)
            fresh.lastTouchedKey = SCDateKey.today
            state.progress.append(fresh)
        }
        save()
    }

    func restartPlan(_ plan: SCPlan) {
        // The completed run was already recorded the moment the last day was ticked,
        // so restarting must not add a second one.
        state.progress.removeAll { $0.planID == plan.id }
        var fresh = SCPlanProgress(planID: plan.id, startKey: SCDateKey.today)
        fresh.lastTouchedKey = SCDateKey.today
        state.progress.append(fresh)
        save()
    }

    func abandonPlan(_ plan: SCPlan) {
        state.progress.removeAll { $0.planID == plan.id }
        save()
    }

    func rebaseToToday(_ plan: SCPlan) {
        guard let idx = state.progress.firstIndex(where: { $0.planID == plan.id }) else { return }
        state.progress[idx] = SCPlanEngine.rebased(state.progress[idx], total: plan.length)
        save()
    }

    func isDayComplete(_ plan: SCPlan, _ dayIndex: Int) -> Bool {
        progress(for: plan.id)?.completed[dayIndex] != nil
    }

    func completionKey(_ plan: SCPlan, _ dayIndex: Int) -> Int? {
        progress(for: plan.id)?.completed[dayIndex]
    }

    @discardableResult
    func markDay(_ plan: SCPlan, _ dayIndex: Int, read: Bool) -> Bool {
        guard dayIndex >= 0 && dayIndex < plan.days.count else { return false }
        guard let idx = state.progress.firstIndex(where: { $0.planID == plan.id }) else { return false }
        let today = SCDateKey.today
        var justFinished = false

        if read {
            guard state.progress[idx].completed[dayIndex] == nil else { return false }
            state.progress[idx].completed[dayIndex] = today
            state.progress[idx].lastTouchedKey = today
            let day = plan.days[dayIndex]
            let verses = content.verses(for: day, in: plan)
            tally(dayKey: today, verses: verses, planDays: 1)
            if state.progress[idx].completedCount >= plan.length {
                state.progress[idx].finishedKey = today
                let run = SCCompletedRun(planID: plan.id,
                                         startKey: state.progress[idx].startKey,
                                         finishedKey: today,
                                         dayCount: plan.length)
                state.completedRuns.append(run)
                justFinished = true
            }
        } else {
            guard let when = state.progress[idx].completed[dayIndex] else { return false }
            state.progress[idx].completed[dayIndex] = nil
            state.progress[idx].lastTouchedKey = today
            if state.progress[idx].finishedKey != nil {
                let finishedOn = state.progress[idx].finishedKey
                state.progress[idx].finishedKey = nil
                if let f = finishedOn {
                    state.completedRuns.removeAll { $0.planID == plan.id && $0.finishedKey == f }
                }
            }
            let day = plan.days[dayIndex]
            let verses = content.verses(for: day, in: plan)
            untally(dayKey: when, verses: verses, planDays: 1)
        }
        save()
        return justFinished
    }

    // MARK: - Standalone verse of the day

    func isSoloRead(_ dayKey: Int) -> Bool {
        record(dayKey)?.soloRead ?? false
    }

    func markSolo(_ dayKey: Int, read: Bool) {
        let verse = content.verseOfDay(for: dayKey)
        if read {
            guard !isSoloRead(dayKey) else { return }
            withRecord(dayKey) { rec in
                rec.soloRead = true
                rec.versesRead += 1
            }
            state.bookTally[verse.book, default: 0] += 1
        } else {
            guard isSoloRead(dayKey) else { return }
            withRecord(dayKey) { rec in
                rec.soloRead = false
                rec.versesRead = max(0, rec.versesRead - 1)
            }
            let current = state.bookTally[verse.book] ?? 0
            state.bookTally[verse.book] = max(0, current - 1)
        }
        save()
    }

    // MARK: - Records

    func record(_ dayKey: Int) -> SCDayRecord? {
        state.records.first { $0.dayKey == dayKey }
    }

    private func withRecord(_ dayKey: Int, _ body: (inout SCDayRecord) -> Void) {
        if let idx = state.records.firstIndex(where: { $0.dayKey == dayKey }) {
            body(&state.records[idx])
            if !state.records[idx].isActive {
                state.records.remove(at: idx)
            }
        } else {
            var rec = SCDayRecord(dayKey: dayKey)
            body(&rec)
            if rec.isActive { state.records.append(rec) }
        }
    }

    private func tally(dayKey: Int, verses: [SCVerse], planDays: Int) {
        withRecord(dayKey) { rec in
            rec.versesRead += verses.count
            rec.planDaysRead += planDays
        }
        for v in verses {
            state.bookTally[v.book, default: 0] += 1
        }
    }

    private func untally(dayKey: Int, verses: [SCVerse], planDays: Int) {
        withRecord(dayKey) { rec in
            rec.versesRead = max(0, rec.versesRead - verses.count)
            rec.planDaysRead = max(0, rec.planDaysRead - planDays)
        }
        for v in verses {
            let current = state.bookTally[v.book] ?? 0
            state.bookTally[v.book] = max(0, current - 1)
        }
    }

    var activeDayKeys: Set<Int> {
        Set(state.records.filter { $0.isActive }.map { $0.dayKey })
    }

    var daysRead: Int { state.records.filter { $0.isActive }.count }

    var versesRead: Int { state.records.reduce(0) { $0 + $1.versesRead } }

    var plansCompleted: Int { state.completedRuns.count }

    var currentStreak: Int {
        let days = activeDayKeys
        guard !days.isEmpty else { return 0 }
        let today = SCDateKey.today
        var cursor = days.contains(today) ? today : SCDateKey.adding(-1, to: today)
        // If neither today nor yesterday was read the streak is over.
        guard days.contains(cursor) else { return 0 }
        var count = 0
        while days.contains(cursor) {
            count += 1
            cursor = SCDateKey.adding(-1, to: cursor)
            if count > 4000 { break }
        }
        return count
    }

    var longestStreak: Int {
        let sorted = activeDayKeys.sorted()
        guard !sorted.isEmpty else { return 0 }
        var best = 1
        var run = 1
        var i = 1
        while i < sorted.count {
            if SCDateKey.days(from: sorted[i - 1], to: sorted[i]) == 1 {
                run += 1
            } else {
                run = 1
            }
            if run > best { best = run }
            i += 1
        }
        return best
    }

    var mostReadBook: (book: String, count: Int)? {
        let filtered = state.bookTally.filter { $0.value > 0 }
        guard let best = filtered.max(by: { a, b in
            if a.value != b.value { return a.value < b.value }
            return SCBookOrder.index(of: a.key) > SCBookOrder.index(of: b.key)
        }) else { return nil }
        return (best.key, best.value)
    }

    /// Verses read per book, richest first, for the History tab.
    var bookLeaderboard: [(book: String, count: Int)] {
        state.bookTally
            .filter { $0.value > 0 }
            .map { (book: $0.key, count: $0.value) }
            .sorted { a, b in
                if a.count != b.count { return a.count > b.count }
                return SCBookOrder.index(of: a.book) < SCBookOrder.index(of: b.book)
            }
    }

    /// Verses read per calendar month for the last `months` months, oldest first.
    func monthlyTotals(months: Int = 12) -> [(label: String, key: Int, value: Int)] {
        var out: [(String, Int, Int)] = []
        let today = SCDateKey.today
        var comps = DateComponents()
        comps.year = SCDateKey.yearOf(today)
        comps.month = SCDateKey.monthIndex(today)
        comps.day = 1
        let cal = SCDateKey.calendar
        guard let thisMonth = cal.date(from: comps) else { return [] }
        var i = months - 1
        while i >= 0 {
            guard let d = cal.date(byAdding: .month, value: -i, to: thisMonth) else { i -= 1; continue }
            let key = SCDateKey.key(from: d)
            let y = SCDateKey.yearOf(key)
            let m = SCDateKey.monthIndex(key)
            let total = state.records
                .filter { SCDateKey.yearOf($0.dayKey) == y && SCDateKey.monthIndex($0.dayKey) == m }
                .reduce(0) { $0 + $1.versesRead }
            out.append((SCDateKey.monthString(key), key, total))
            i -= 1
        }
        return out.map { (label: $0.0, key: $0.1, value: $0.2) }
    }

    // MARK: - Favourites

    var favouriteVerses: [SCVerse] {
        state.favourites.compactMap { content.verse(ref: $0) }
    }

    func isFavourite(_ ref: String) -> Bool {
        state.favourites.contains(ref)
    }

    func toggleFavourite(_ ref: String) {
        if let idx = state.favourites.firstIndex(of: ref) {
            state.favourites.remove(at: idx)
        } else {
            state.favourites.append(ref)
        }
        save()
    }

    // MARK: - Journal

    var journalEntries: [SCJournalEntry] {
        state.journal
            .filter { !$0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .sorted { $0.dayKey > $1.dayKey }
    }

    func journalText(_ dayKey: Int) -> String {
        state.journal.first { $0.dayKey == dayKey }?.text ?? ""
    }

    func journalEntry(_ dayKey: Int) -> SCJournalEntry? {
        state.journal.first { $0.dayKey == dayKey }
    }

    func setJournal(_ text: String, dayKey: Int, planID: String?, dayIndex: Int?) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if let idx = state.journal.firstIndex(where: { $0.dayKey == dayKey }) {
            if trimmed.isEmpty {
                state.journal.remove(at: idx)
            } else {
                state.journal[idx].text = trimmed
                state.journal[idx].planID = planID ?? state.journal[idx].planID
                state.journal[idx].dayIndex = dayIndex ?? state.journal[idx].dayIndex
            }
        } else if !trimmed.isEmpty {
            state.journal.append(SCJournalEntry(dayKey: dayKey, text: trimmed, planID: planID, dayIndex: dayIndex))
        }
        save()
    }

    func deleteJournal(_ dayKey: Int) {
        state.journal.removeAll { $0.dayKey == dayKey }
        save()
    }

    // MARK: - Reset

    func resetEverything() {
        var fresh = SCPersistedState()
        fresh.settings = state.settings          // preferences survive; progress does not
        fresh.settings.onboardingSeen = true
        fresh.firstLaunchKey = SCDateKey.today
        state = fresh
        save()
    }
}
