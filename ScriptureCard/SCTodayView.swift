import SwiftUI

struct SCTodayView: View {

    @EnvironmentObject var store: SCStore
    @EnvironmentObject var router: SCRouter

    @State private var journalDraft: String = ""
    @State private var journalLoadedKey: Int = 0
    @FocusState private var journalFocused: Bool
    @State private var showFinishedBanner = false
    @State private var finishedPlanTitle = ""

    private let content = SCContent.shared

    private var type: SCType { SCType(store.settings.textSize) }
    private var todayKey: Int { SCDateKey.today }

    var body: some View {
        SCScreen(title: "Today",
                 subtitle: SCDateKey.weekdayLongString(todayKey) + ", " + SCDateKey.longString(todayKey)) {

            streakCard

            // Lives here rather than inside `planSection`: the moment the last day is ticked
            // the plan leaves `activeProgress`, `focusPlan()` returns nil and the whole plan
            // card is torn down, so a banner nested in it could never be seen.
            if showFinishedBanner {
                finishedBanner
            }

            if let focus = store.focusPlan() {
                planSection(plan: focus.plan, progress: focus.progress)
            } else {
                standaloneSection
            }

            journalCard

            otherPlansSection

            if store.focusPlan() != nil {
                dailyVerseFooter
            }

            Text("King James Version, public domain.")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
        }
        .onAppear { loadJournal() }
        // Switching tabs destroys this view outright, and neither the Done button nor the
        // focus change fires on teardown, so without this a note typed with the keyboard
        // still up is lost.
        .onDisappear { saveJournal() }
    }

    // MARK: - Plan completion

    private var finishedBanner: some View {
        SCCard(tint: SCPalette.parchmentDeep, stroke: SCPalette.gold.opacity(0.4)) {
            Text("You finished " + finishedPlanTitle)
                .font(type.heading)
                .foregroundColor(SCPalette.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text("It has moved to the completed shelf with today's date. Start another whenever you are ready.")
                .font(type.caption)
                .foregroundColor(SCPalette.inkSoft)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 8) {
                SCSecondaryButton(title: "Browse plans") {
                    showFinishedBanner = false
                    router.tab = 1
                }
                SCSecondaryButton(title: "Dismiss", tint: SCPalette.inkSoft) {
                    showFinishedBanner = false
                }
            }
        }
    }

    // MARK: - Streak

    private var streakCard: some View {
        SCCard {
            HStack(alignment: .center, spacing: 14) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        SCFlameGlyph(size: 17, color: store.currentStreak > 0 ? SCPalette.ember : SCPalette.inkFaint)
                        Text(streakHeadline)
                            .font(type.heading)
                            .foregroundColor(SCPalette.ink)
                    }
                    Text(streakCaption)
                        .font(type.caption)
                        .foregroundColor(SCPalette.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }

            SCWeekStrip(dayKeys: lastSevenKeys,
                        activeKeys: store.activeDayKeys)
        }
    }

    private var lastSevenKeys: [Int] {
        var out: [Int] = []
        var i = 6
        while i >= 0 {
            out.append(SCDateKey.adding(-i, to: todayKey))
            i -= 1
        }
        return out
    }

    private var streakHeadline: String {
        let s = store.currentStreak
        if s == 0 { return "No streak yet" }
        return s == 1 ? "One day running" : "\(s) days running"
    }

    private var streakCaption: String {
        let read = store.daysRead
        if read == 0 {
            return "Mark a day as read and this strip starts filling in."
        }
        return "\(read) " + (read == 1 ? "day" : "days") + " read in all. Longest run so far: \(store.longestStreak)."
    }

    // MARK: - Active plan

    @ViewBuilder
    private func planSection(plan: SCPlan, progress: SCPlanProgress) -> some View {
        let status = SCPlanEngine.status(plan: plan, progress: progress, policy: store.settings.catchUp)
        let day = plan.days[status.displayIndex]
        let verses = content.verses(for: day, in: plan)

        if status.policy == .strict && status.daysBehind > 0 && !status.isFinished {
            SCCard(tint: SCPalette.emberSoft, stroke: SCPalette.ember.opacity(0.35)) {
                Text(status.daysBehind == 1 ? "One day behind" : "\(status.daysBehind) days behind")
                    .font(type.heading)
                    .foregroundColor(SCPalette.ember)
                Text("Strict pacing pins day one to the date you started. You can move the whole schedule so that day \(status.displayIndex + 1) lands on today. Nothing you have already read is lost.")
                    .font(type.caption)
                    .foregroundColor(SCPalette.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                SCSecondaryButton(title: "Rebase to today", tint: SCPalette.ember) {
                    store.rebaseToToday(plan)
                }
            }
        }

        SCCard {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(plan.title)
                        .font(type.title)
                        .foregroundColor(SCPalette.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(status.headline + "  |  " + day.title)
                        .font(type.caption)
                        .foregroundColor(SCPalette.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
                SCProgressRing(fraction: status.fraction,
                               size: 44,
                               lineWidth: 4,
                               label: status.percentText)
            }

            if store.settings.showOrnaments {
                SCOrnamentRule()
            }

            ForEach(verses) { v in
                SCVerseBlock(verse: v,
                             type: type,
                             showNote: store.settings.showEditorNotes,
                             showDropCap: v.id == verses.first?.id)
                    .padding(.bottom, v.id == verses.last?.id ? 0 : 6)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Reflection")
                    .font(type.micro)
                    .foregroundColor(SCPalette.gold)
                Text(day.reflection)
                    .font(type.reflection)
                    .foregroundColor(SCPalette.inkSoft)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 4)

            if status.isFinished {
                SCCard(tint: SCPalette.parchmentDeep, stroke: SCPalette.goldSoft, padding: 12) {
                    Text("Plan complete")
                        .font(type.captionStrong)
                        .foregroundColor(SCPalette.ink)
                    Text("Finished on " + SCDateKey.longString(status.finishedKey ?? todayKey) + ". It now sits in the completed shelf on the Plans tab and can be restarted whenever you like.")
                        .font(type.caption)
                        .foregroundColor(SCPalette.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
            } else if status.todayComplete {
                HStack(spacing: 8) {
                    SCCheckGlyph(size: 18)
                    Text("Day \(status.displayIndex + 1) read" + completionSuffix(plan: plan, index: status.displayIndex))
                        .font(type.captionStrong)
                        .foregroundColor(SCPalette.sage)
                    Spacer(minLength: 0)
                    Button(action: { store.markDay(plan, status.displayIndex, read: false) }) {
                        Text("Undo")
                            .font(type.caption)
                            .foregroundColor(SCPalette.inkSoft)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Capsule().fill(SCPalette.parchmentDeep))
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.top, 2)
            } else {
                SCPrimaryButton(title: "Mark as read",
                                subtitle: "Day \(status.displayIndex + 1) of \(status.total)",
                                tint: SCPalette.ink) {
                    let finished = store.markDay(plan, status.displayIndex, read: true)
                    if finished {
                        finishedPlanTitle = plan.title
                        showFinishedBanner = true
                    }
                }
                .padding(.top, 4)
            }

            NavigationLink(destination: SCPlanDetailView(plan: plan)) {
                HStack(spacing: 5) {
                    Text("Open the whole plan")
                        .font(type.caption)
                        .foregroundColor(SCPalette.inkSoft)
                    SCChevronGlyph(size: 12)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private func completionSuffix(plan: SCPlan, index: Int) -> String {
        guard let key = store.completionKey(plan, index) else { return "" }
        if key == todayKey { return " today" }
        return " on " + SCDateKey.mediumString(key)
    }

    // MARK: - Standalone verse of the day

    private var standaloneSection: some View {
        let verse = content.verseOfDay(for: todayKey)
        let done = store.isSoloRead(todayKey)
        return VStack(alignment: .leading, spacing: 14) {
            SCCard {
                HStack(alignment: .top, spacing: 8) {
                    Text("Verse of the day")
                        .font(type.micro)
                        .foregroundColor(SCPalette.gold)
                    Spacer(minLength: 0)
                    Button(action: { store.toggleFavourite(verse.id) }) {
                        SCBookmarkGlyph(size: 18, filled: store.isFavourite(verse.id))
                            .padding(6)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                if store.settings.showOrnaments {
                    SCOrnamentRule()
                }

                SCVerseBlock(verse: verse,
                             type: type,
                             showNote: store.settings.showEditorNotes,
                             large: true)

                if done {
                    HStack(spacing: 8) {
                        SCCheckGlyph(size: 18)
                        Text("Read today")
                            .font(type.captionStrong)
                            .foregroundColor(SCPalette.sage)
                        Spacer(minLength: 0)
                        Button(action: { store.markSolo(todayKey, read: false) }) {
                            Text("Undo")
                                .font(type.caption)
                                .foregroundColor(SCPalette.inkSoft)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Capsule().fill(SCPalette.parchmentDeep))
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                } else {
                    SCPrimaryButton(title: "Mark as read",
                                    subtitle: "Today's card",
                                    tint: SCPalette.ink) {
                        store.markSolo(todayKey, read: true)
                    }
                }

                NavigationLink(destination: SCVerseDetailView(verse: verse)) {
                    HStack(spacing: 5) {
                        Text("Open this verse")
                            .font(type.caption)
                            .foregroundColor(SCPalette.inkSoft)
                        SCChevronGlyph(size: 12)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }

            SCEmptyState(title: "No plan running",
                         message: "The daily card is yours whether or not a plan is open. But the app is built around plans: pick one, read a day at a time, and miss as many days as life requires.",
                         actionTitle: "Browse \(content.planCount) plans") {
                router.tab = 1
            }
        }
    }

    // MARK: - Journal

    private var journalCard: some View {
        SCCard {
            HStack(alignment: .center, spacing: 8) {
                Text("Note for today")
                    .font(type.micro)
                    .foregroundColor(SCPalette.gold)
                Spacer(minLength: 0)
                if journalFocused {
                    Button(action: {
                        journalFocused = false
                        saveJournal()
                    }) {
                        Text("Done")
                            .font(type.captionStrong)
                            .foregroundColor(SCPalette.ink)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(Capsule().fill(SCPalette.parchmentDeep))
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(SCPalette.parchment)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(journalFocused ? SCPalette.gold.opacity(0.6) : SCPalette.rule, lineWidth: 1)

                if journalDraft.isEmpty && !journalFocused {
                    Text("A line about what stayed with you. Kept on this device only.")
                        .font(type.caption)
                        .foregroundColor(SCPalette.inkFaint)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 14)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $journalDraft)
                    .focused($journalFocused)
                    .font(type.body)
                    .foregroundColor(SCPalette.ink)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 7)
                    .frame(minHeight: 84)
                    // Without this the editor keeps its own opaque white backing, which covers
                    // the parchment fill and the placeholder drawn underneath it.
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
            }
            .frame(minHeight: 84)
            .contentShape(Rectangle())
            .onTapGesture { journalFocused = true }

            if !journalDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Button(action: {
                    journalDraft = ""
                    journalFocused = false
                    store.deleteJournal(todayKey)
                }) {
                    Text("Clear this note")
                        .font(type.caption)
                        .foregroundColor(SCPalette.ember)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .onChange(of: journalFocused) { focused in
            if !focused { saveJournal() }
        }
    }

    private func loadJournal() {
        guard journalLoadedKey != todayKey else { return }
        journalDraft = store.journalText(todayKey)
        journalLoadedKey = todayKey
    }

    private func saveJournal() {
        let focus = store.focusPlan()
        var idx: Int? = nil
        if let f = focus {
            let st = SCPlanEngine.status(plan: f.plan, progress: f.progress, policy: store.settings.catchUp)
            idx = st.displayIndex
        }
        store.setJournal(journalDraft, dayKey: todayKey, planID: focus?.plan.id, dayIndex: idx)
    }

    // MARK: - Other plans

    @ViewBuilder
    private var otherPlansSection: some View {
        let others = store.activeProgress.dropFirst().compactMap { p -> (SCPlan, SCPlanProgress)? in
            guard let plan = content.plan(id: p.planID) else { return nil }
            return (plan, p)
        }
        if !others.isEmpty {
            Text("Also running")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
                .padding(.top, 4)

            ForEach(Array(others.enumerated()), id: \.offset) { _, pair in
                let st = SCPlanEngine.status(plan: pair.0, progress: pair.1, policy: store.settings.catchUp)
                NavigationLink(destination: SCPlanDetailView(plan: pair.0)) {
                    SCCard(padding: 12) {
                        HStack(spacing: 12) {
                            SCProgressRing(fraction: st.fraction, size: 34, lineWidth: 3.5)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(pair.0.title)
                                    .font(type.captionStrong)
                                    .foregroundColor(SCPalette.ink)
                                    .lineLimit(1)
                                Text(st.headline + "  |  " + st.scheduleNote)
                                    .font(type.caption)
                                    .foregroundColor(SCPalette.inkFaint)
                                    .lineLimit(1)
                            }
                            Spacer(minLength: 0)
                            SCChevronGlyph(size: 13)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    // MARK: - Daily verse footer when a plan is running

    private var dailyVerseFooter: some View {
        let verse = content.verseOfDay(for: todayKey)
        return NavigationLink(destination: SCVerseDetailView(verse: verse)) {
            SCCard(tint: SCPalette.parchmentDeep, stroke: SCPalette.rule, padding: 13) {
                Text("Verse of the day")
                    .font(type.micro)
                    .foregroundColor(SCPalette.gold)
                Text(verse.text)
                    .font(type.body)
                    .foregroundColor(SCPalette.inkSoft)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 6) {
                    Text(verse.reference)
                        .font(type.reference)
                        .foregroundColor(SCPalette.ink)
                    Spacer(minLength: 0)
                    SCChevronGlyph(size: 12)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Seven day strip

struct SCWeekStrip: View {
    let dayKeys: [Int]
    let activeKeys: Set<Int>
    /// The card's width. A Canvas closure's own size cannot be used to decide the frame it is
    /// asked to fill, so the figure comes from the enclosing screen's measurement instead.
    var width: CGFloat? = nil

    @Environment(\.scCanvasWidth) private var canvasWidth

    var body: some View {
        let width = self.width ?? canvasWidth
        let count = max(1, dayKeys.count)
        let gap: CGFloat = 6
        let cell = max(18, (width - gap * CGFloat(count - 1)) / CGFloat(count))
        let height = cell + 18

        Canvas { ctx, size in
            for (i, key) in dayKeys.enumerated() {
                let x = CGFloat(i) * (cell + gap)
                let rect = CGRect(x: x, y: 0, width: cell, height: cell)
                let path = Path(roundedRect: rect, cornerRadius: cell * 0.26)
                let isToday = key == SCDateKey.today
                if activeKeys.contains(key) {
                    ctx.fill(path, with: .color(SCPalette.gold.opacity(0.85)))
                } else {
                    ctx.fill(path, with: .color(SCPalette.parchmentDeep))
                }
                if isToday {
                    ctx.stroke(path, with: .color(SCPalette.ink), lineWidth: 1.6)
                } else {
                    ctx.stroke(path, with: .color(SCPalette.rule), lineWidth: 1)
                }

                let letter = String(SCDateKey.weekdayString(key).prefix(1))
                let text = Text(letter)
                    .font(.system(size: 10, weight: isToday ? .semibold : .regular))
                    .foregroundColor(SCPalette.inkSoft)
                ctx.draw(text, at: CGPoint(x: x + cell / 2, y: cell + 9), anchor: .center)

                if activeKeys.contains(key) {
                    var tick = Path()
                    tick.move(to: CGPoint(x: rect.minX + cell * 0.26, y: rect.midY))
                    tick.addLine(to: CGPoint(x: rect.midX - cell * 0.02, y: rect.maxY - cell * 0.28))
                    tick.addLine(to: CGPoint(x: rect.maxX - cell * 0.24, y: rect.minY + cell * 0.30))
                    ctx.stroke(tick, with: .color(SCPalette.card),
                               style: StrokeStyle(lineWidth: max(1.4, cell * 0.09),
                                                  lineCap: .round, lineJoin: .round))
                }
            }
            _ = size
        }
        .frame(width: width, height: height)
    }
}
