import SwiftUI

struct SCHistoryView: View {

    @EnvironmentObject var store: SCStore
    @EnvironmentObject var router: SCRouter

    private let content = SCContent.shared
    private var type: SCType { SCType(store.settings.textSize) }

    var body: some View {
        SCScreen(title: "History",
                 subtitle: store.daysRead == 0
                    ? "Nothing recorded yet"
                    : SCCount.phrase(store.daysRead, "day", "days") + " recorded") {

            statsCard
            yearCard
            monthCard
            booksCard
            completedCard
            journalCard
        }
    }

    // MARK: - Totals

    private var statsCard: some View {
        SCCard {
            Text("TOTALS")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)

            HStack(spacing: 6) {
                SCStatBlock(value: "\(store.daysRead)", label: "Days read")
                divider
                SCStatBlock(value: "\(store.currentStreak)", label: "Current streak",
                            tint: store.currentStreak > 0 ? SCPalette.ember : SCPalette.ink)
                divider
                SCStatBlock(value: "\(store.longestStreak)", label: "Longest streak")
            }

            Rectangle().fill(SCPalette.rule).frame(height: 1)

            HStack(spacing: 6) {
                SCStatBlock(value: "\(store.versesRead)", label: "Passages read")
                divider
                SCStatBlock(value: "\(store.plansCompleted)", label: "Plans completed")
                divider
                SCStatBlock(value: mostReadValue, label: "Most read book", tint: SCPalette.gold)
            }
        }
    }

    private var divider: some View {
        Rectangle()
            .fill(SCPalette.rule)
            .frame(width: 1, height: 34)
    }

    private var mostReadValue: String {
        guard let best = store.mostReadBook else { return "\u{2014}" }
        return SCBookOrder.abbreviation(for: best.book)
    }

    // MARK: - Year grid

    private var yearCard: some View {
        SCCard {
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("THE LAST YEAR")
                        .font(type.micro)
                        .foregroundColor(SCPalette.inkFaint)
                    Text("One square a day, shaded by how much was read.")
                        .font(type.caption)
                        .foregroundColor(SCPalette.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }

            SCYearGrid(records: store.state.records)

            HStack(spacing: 8) {
                Text("Less")
                    .font(type.micro)
                    .foregroundColor(SCPalette.inkFaint)
                ForEach(0..<4, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(SCYearGrid.shade(for: i))
                        .frame(width: 11, height: 11)
                        .overlay(RoundedRectangle(cornerRadius: 2).stroke(SCPalette.rule, lineWidth: 0.6))
                }
                Text("More")
                    .font(type.micro)
                    .foregroundColor(SCPalette.inkFaint)
                Spacer(minLength: 0)
            }
        }
    }

    // MARK: - Monthly bars

    private var monthCard: some View {
        let totals = store.monthlyTotals(months: 12)
        return SCCard {
            Text("PASSAGES PER MONTH")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)

            if totals.allSatisfy({ $0.value == 0 }) {
                Text("Nothing has been marked as read in the last twelve months. The bars fill in as you go.")
                    .font(type.caption)
                    .foregroundColor(SCPalette.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
            }

            SCMonthBars(values: totals.map { $0.value },
                        labels: totals.map { $0.label })
        }
    }

    // MARK: - Books

    @ViewBuilder
    private var booksCard: some View {
        let board = Array(store.bookLeaderboard.prefix(8))
        if !board.isEmpty {
            SCCard {
                Text("BOOKS YOU HAVE READ FROM")
                    .font(type.micro)
                    .foregroundColor(SCPalette.inkFaint)
                let top = max(1, board.first?.count ?? 1)
                ForEach(Array(board.enumerated()), id: \.offset) { _, row in
                    HStack(spacing: 8) {
                        Text(row.book)
                            .font(type.caption)
                            .foregroundColor(SCPalette.ink)
                            .frame(width: 92, alignment: .leading)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(SCPalette.parchmentDeep)
                                Capsule()
                                    .fill(SCPalette.gold.opacity(0.8))
                                    .frame(width: max(3, geo.size.width * CGFloat(row.count) / CGFloat(top)))
                            }
                        }
                        .frame(height: 10)
                        Text("\(row.count)")
                            .font(type.micro)
                            .foregroundColor(SCPalette.inkSoft)
                            .frame(width: 26, alignment: .trailing)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }

    // MARK: - Completed runs

    @ViewBuilder
    private var completedCard: some View {
        let runs = store.state.completedRuns.sorted { $0.finishedKey > $1.finishedKey }
        if !runs.isEmpty {
            SCCard {
                Text("PLANS COMPLETED")
                    .font(type.micro)
                    .foregroundColor(SCPalette.inkFaint)
                ForEach(runs) { run in
                    HStack(alignment: .top, spacing: 10) {
                        SCCheckGlyph(size: 15)
                            .padding(.top, 2)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(content.plan(id: run.planID)?.title ?? run.planID)
                                .font(type.captionStrong)
                                .foregroundColor(SCPalette.ink)
                                .multilineTextAlignment(.leading)
                            Text("\(run.dayCount) days, finished " + SCDateKey.longString(run.finishedKey)
                                 + "  |  took \(run.elapsedDays) " + (run.elapsedDays == 1 ? "day" : "days"))
                                .font(type.micro)
                                .foregroundColor(SCPalette.inkFaint)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 3)
                }
            }
        }
    }

    // MARK: - Journal

    @ViewBuilder
    private var journalCard: some View {
        let entries = store.journalEntries
        if entries.isEmpty {
            SCEmptyState(title: "No notes yet",
                         message: "Anything you type into the note field on the Today tab is collected here, newest first, and can be reopened and edited.",
                         actionTitle: "Go to Today") {
                router.tab = 0
            }
        } else {
            Text("NOTES  |  \(entries.count)")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
                .padding(.top, 6)

            ForEach(entries) { entry in
                NavigationLink(destination: SCJournalDayView(dayKey: entry.dayKey)) {
                    SCCard(padding: 13) {
                        HStack(spacing: 8) {
                            Text(SCDateKey.longString(entry.dayKey))
                                .font(type.captionStrong)
                                .foregroundColor(SCPalette.gold)
                            Spacer(minLength: 0)
                            SCChevronGlyph(size: 12)
                        }
                        Text(entry.text)
                            .font(type.reflection)
                            .foregroundColor(SCPalette.inkSoft)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        if let pid = entry.planID, let plan = content.plan(id: pid) {
                            Text(plan.title + (entry.dayIndex != nil ? "  |  day \((entry.dayIndex ?? 0) + 1)" : ""))
                                .font(type.micro)
                                .foregroundColor(SCPalette.inkFaint)
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - Year grid drawing

struct SCYearGrid: View {
    let records: [SCDayRecord]
    /// The card's width, measured by the enclosing screen rather than read off UIScreen, so
    /// the grid fills its card in landscape as well as portrait.
    var width: CGFloat? = nil

    @Environment(\.scCanvasWidth) private var canvasWidth

    static func shade(for level: Int) -> Color {
        switch level {
        case 0: return SCPalette.parchmentDeep
        case 1: return SCPalette.goldSoft
        case 2: return SCPalette.gold.opacity(0.72)
        default: return SCPalette.gold
        }
    }

    private static func level(_ verses: Int) -> Int {
        if verses <= 0 { return 0 }
        if verses <= 2 { return 1 }
        if verses <= 5 { return 2 }
        return 3
    }

    var body: some View {
        let width = self.width ?? canvasWidth
        let columns = 53
        let rows = 7
        let gap: CGFloat = 1.6
        let cell = max(3, (width - gap * CGFloat(columns - 1)) / CGFloat(columns))
        let height = cell * CGFloat(rows) + gap * CGFloat(rows - 1)

        let todayKey = SCDateKey.today
        // The grid ends on the column containing today; the last cell is today's weekday row.
        let todayWeekday = SCDateKey.weekdayIndex(todayKey)
        let totalCells = (columns - 1) * rows + todayWeekday + 1
        let startKey = SCDateKey.adding(-(totalCells - 1), to: todayKey)

        var lookup: [Int: Int] = [:]
        for r in records where r.isActive { lookup[r.dayKey] = r.versesRead }

        return Canvas { ctx, size in
            var offset = 0
            while offset < totalCells {
                let key = SCDateKey.adding(offset, to: startKey)
                let col = offset / rows
                let row = offset % rows
                let x = CGFloat(col) * (cell + gap)
                let y = CGFloat(row) * (cell + gap)
                let rect = CGRect(x: x, y: y, width: cell, height: cell)
                let path = Path(roundedRect: rect, cornerRadius: max(0.8, cell * 0.22))
                let verses = lookup[key] ?? 0
                ctx.fill(path, with: .color(SCYearGrid.shade(for: SCYearGrid.level(verses))))
                if key == todayKey {
                    ctx.stroke(path, with: .color(SCPalette.ink), lineWidth: 1.1)
                } else if verses == 0 {
                    ctx.stroke(path, with: .color(SCPalette.rule.opacity(0.7)), lineWidth: 0.5)
                }
                offset += 1
            }
            _ = size
        }
        .frame(width: width, height: height)
    }
}

// MARK: - Monthly bars

struct SCMonthBars: View {
    let values: [Int]
    let labels: [String]
    /// As with the year grid: the card's measured width, not a static screen figure.
    var width: CGFloat? = nil

    @Environment(\.scCanvasWidth) private var canvasWidth

    var body: some View {
        let width = self.width ?? canvasWidth
        let count = max(1, values.count)
        let gap: CGFloat = 5
        let barWidth = max(6, (width - gap * CGFloat(count - 1)) / CGFloat(count))
        let plotHeight: CGFloat = 86
        /// Headroom kept clear at the top so the count printed above the tallest bar is never
        /// drawn outside the Canvas (it used to land at y = -6 and vanish on the peak month).
        let barCeiling: CGFloat = plotHeight - 14
        let peak = max(1, values.max() ?? 1)

        Canvas { ctx, size in
            var baseline = Path()
            baseline.move(to: CGPoint(x: 0, y: plotHeight))
            baseline.addLine(to: CGPoint(x: width, y: plotHeight))
            ctx.stroke(baseline, with: .color(SCPalette.rule), lineWidth: 1)

            for (i, v) in values.enumerated() {
                let x = CGFloat(i) * (barWidth + gap)
                let h = v <= 0 ? 2 : max(3, barCeiling * CGFloat(v) / CGFloat(peak))
                let rect = CGRect(x: x, y: plotHeight - h, width: barWidth, height: h)
                let path = Path(roundedRect: rect, cornerRadius: min(3, barWidth * 0.3))
                ctx.fill(path, with: .color(v <= 0 ? SCPalette.parchmentDeep : SCPalette.gold.opacity(0.85)))

                if i < labels.count {
                    let t = Text(labels[i])
                        .font(.system(size: 8.5))
                        .foregroundColor(SCPalette.inkFaint)
                    ctx.draw(t, at: CGPoint(x: x + barWidth / 2, y: plotHeight + 9), anchor: .center)
                }
                if v > 0 {
                    let t = Text("\(v)")
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundColor(SCPalette.inkSoft)
                    ctx.draw(t, at: CGPoint(x: x + barWidth / 2, y: plotHeight - h - 6), anchor: .center)
                }
            }
            _ = size
        }
        .frame(width: width, height: plotHeight + 20)
    }
}

// MARK: - Reopen one day

struct SCJournalDayView: View {
    let dayKey: Int

    @EnvironmentObject var store: SCStore
    @Environment(\.presentationMode) private var presentation

    @State private var draft: String = ""
    @State private var loaded = false
    @State private var confirmDelete = false
    @FocusState private var focused: Bool

    private let content = SCContent.shared
    private var type: SCType { SCType(store.settings.textSize) }

    var body: some View {
        SCScreen(title: SCDateKey.weekdayLongString(dayKey),
                 subtitle: SCDateKey.longString(dayKey),
                 showsBack: true,
                 onBack: {
                     save()
                     presentation.wrappedValue.dismiss()
                 }) {

            SCCard {
                HStack(spacing: 8) {
                    Text("NOTE")
                        .font(type.micro)
                        .foregroundColor(SCPalette.gold)
                    Spacer(minLength: 0)
                    if focused {
                        Button(action: {
                            focused = false
                            save()
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
                    RoundedRectangle(cornerRadius: 10).fill(SCPalette.parchment)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(focused ? SCPalette.gold.opacity(0.6) : SCPalette.rule, lineWidth: 1)
                    if draft.isEmpty && !focused {
                        Text("This day has no note.")
                            .font(type.caption)
                            .foregroundColor(SCPalette.inkFaint)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 14)
                            .allowsHitTesting(false)
                    }
                    TextEditor(text: $draft)
                        .focused($focused)
                        .font(type.body)
                        .foregroundColor(SCPalette.ink)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 7)
                        .frame(minHeight: 110)
                        // Same as the Today editor: the default opaque backing hides both the
                        // parchment fill and the placeholder behind it.
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                }
                .frame(minHeight: 110)
                .contentShape(Rectangle())
                .onTapGesture { focused = true }
            }

            readingCard

            if confirmDelete {
                SCCard(tint: SCPalette.emberSoft, stroke: SCPalette.ember.opacity(0.4)) {
                    Text("Delete this note")
                        .font(type.heading)
                        .foregroundColor(SCPalette.ember)
                    Text("The text is removed from this device. Reading history for the day is untouched.")
                        .font(type.caption)
                        .foregroundColor(SCPalette.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    SCPrimaryButton(title: "Delete", tint: SCPalette.ember) {
                        store.deleteJournal(dayKey)
                        draft = ""
                        confirmDelete = false
                    }
                    SCSecondaryButton(title: "Keep it", tint: SCPalette.inkSoft) {
                        confirmDelete = false
                    }
                }
            } else if !draft.isEmpty {
                SCSecondaryButton(title: "Delete this note", tint: SCPalette.ember) {
                    focused = false
                    confirmDelete = true
                }
            }
        }
        .onAppear {
            if !loaded {
                draft = store.journalText(dayKey)
                loaded = true
            }
        }
    }

    private var readingCard: some View {
        let rec = store.record(dayKey)
        let entry = store.journalEntry(dayKey)
        return SCCard(tint: SCPalette.parchmentDeep, stroke: SCPalette.rule, padding: 13) {
            Text("THAT DAY")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
            if let r = rec, r.isActive {
                Text(SCJournalDayView.summary(for: r))
                    .font(type.caption)
                    .foregroundColor(SCPalette.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("Nothing was marked as read on this date.")
                    .font(type.caption)
                    .foregroundColor(SCPalette.inkSoft)
            }
            if let pid = entry?.planID, let plan = content.plan(id: pid) {
                NavigationLink(destination: SCPlanDetailView(plan: plan)) {
                    HStack(spacing: 6) {
                        Text("Open " + plan.title)
                            .font(type.caption)
                            .foregroundColor(SCPalette.ink)
                        SCChevronGlyph(size: 12)
                        Spacer(minLength: 0)
                    }
                    .padding(.top, 2)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    private func save() {
        let existing = store.journalEntry(dayKey)
        store.setJournal(draft, dayKey: dayKey, planID: existing?.planID, dayIndex: existing?.dayIndex)
    }

    static func summary(for r: SCDayRecord) -> String {
        var parts: [String] = []
        let noun = r.versesRead == 1 ? "passage" : "passages"
        parts.append("\(r.versesRead) \(noun) read")
        if r.planDaysRead > 0 {
            let dayNoun = r.planDaysRead == 1 ? "day" : "days"
            parts.append("\(r.planDaysRead) plan \(dayNoun)")
        }
        if r.soloRead {
            parts.append("including the verse of the day")
        }
        return parts.joined(separator: ", ")
    }
}
