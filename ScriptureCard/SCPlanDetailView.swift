import SwiftUI

struct SCPlanDetailView: View {

    let plan: SCPlan

    @EnvironmentObject var store: SCStore
    @Environment(\.presentationMode) private var presentation

    @State private var confirmRestart = false
    @State private var confirmAbandon = false

    private let content = SCContent.shared
    private var type: SCType { SCType(store.settings.textSize) }

    private var progress: SCPlanProgress? { store.progress(for: plan.id) }
    private var status: SCPlanEngine.Status? {
        progress.map { SCPlanEngine.status(plan: plan, progress: $0, policy: store.settings.catchUp) }
    }

    var body: some View {
        SCScreen(title: plan.title,
                 subtitle: plan.lengthLabel + "  |  " + plan.theme.title,
                 showsBack: true,
                 onBack: { presentation.wrappedValue.dismiss() }) {

            overviewCard
            actionCard

            if let s = status, s.policy == .strict, s.daysBehind > 0, !s.isFinished {
                behindCard(s)
            }

            Text("THE DAYS")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
                .padding(.top, 6)

            ForEach(plan.days) { day in
                dayRow(day)
            }

            Text("Every reading in this plan is King James Version, which is in the public domain. The reflections are written for this app.")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)
        }
    }

    // MARK: - Overview

    private var overviewCard: some View {
        SCCard {
            HStack(alignment: .top, spacing: 12) {
                SCDropCap(letter: String(plan.title.prefix(1)), size: 42)
                VStack(alignment: .leading, spacing: 3) {
                    Text(plan.subtitle)
                        .font(type.captionStrong)
                        .foregroundColor(SCPalette.ink)
                        .fixedSize(horizontal: false, vertical: true)
                    Text("\(plan.length) days  |  \(content.verseCount(for: plan)) readings")
                        .font(type.caption)
                        .foregroundColor(SCPalette.inkFaint)
                }
                Spacer(minLength: 0)
            }

            if store.settings.showOrnaments {
                SCOrnamentRule()
            }

            Text(plan.summary)
                .font(type.reflection)
                .foregroundColor(SCPalette.inkSoft)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)

            if let s = status {
                HStack(spacing: 12) {
                    SCProgressRing(fraction: s.fraction, size: 46, lineWidth: 4,
                                   tint: s.isFinished ? SCPalette.sage : SCPalette.gold,
                                   label: s.percentText)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("\(s.completedCount) of \(s.total) days read")
                            .font(type.captionStrong)
                            .foregroundColor(SCPalette.ink)
                        Text(s.scheduleNote)
                            .font(type.caption)
                            .foregroundColor(SCPalette.inkSoft)
                            .fixedSize(horizontal: false, vertical: true)
                        if !s.isFinished {
                            Text("Estimated finish: " + SCDateKey.longString(s.estimatedFinishKey))
                                .font(type.caption)
                                .foregroundColor(SCPalette.inkFaint)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    Spacer(minLength: 0)
                }
                .padding(.top, 2)
            } else {
                Text("Not started. Under the current setting the plan uses " + store.settings.catchUp.title.lowercased() + " pacing.")
                    .font(type.caption)
                    .foregroundColor(SCPalette.inkFaint)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    // MARK: - Actions

    @ViewBuilder
    private var actionCard: some View {
        if confirmRestart {
            SCCard(tint: SCPalette.emberSoft, stroke: SCPalette.ember.opacity(0.4)) {
                Text("Restart this plan")
                    .font(type.heading)
                    .foregroundColor(SCPalette.ember)
                Text("Day one moves to today and every tick on this plan is cleared. A completed run stays in your history and in the totals on the History tab.")
                    .font(type.caption)
                    .foregroundColor(SCPalette.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                SCPrimaryButton(title: "Yes, restart from day one", tint: SCPalette.ember) {
                    store.restartPlan(plan)
                    confirmRestart = false
                }
                SCSecondaryButton(title: "Keep my progress", tint: SCPalette.inkSoft) {
                    confirmRestart = false
                }
            }
        } else if confirmAbandon {
            SCCard(tint: SCPalette.emberSoft, stroke: SCPalette.ember.opacity(0.4)) {
                Text("Remove this plan")
                    .font(type.heading)
                    .foregroundColor(SCPalette.ember)
                Text("The plan leaves your running list and its ticks are forgotten. Days already counted stay in your reading history, because you did read them.")
                    .font(type.caption)
                    .foregroundColor(SCPalette.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                SCPrimaryButton(title: "Remove it", tint: SCPalette.ember) {
                    store.abandonPlan(plan)
                    confirmAbandon = false
                }
                SCSecondaryButton(title: "Keep it running", tint: SCPalette.inkSoft) {
                    confirmAbandon = false
                }
            }
        } else if let s = status {
            SCCard {
                if s.isFinished {
                    Text("Completed on " + SCDateKey.longString(s.finishedKey ?? SCDateKey.today))
                        .font(type.captionStrong)
                        .foregroundColor(SCPalette.sage)
                    SCPrimaryButton(title: "Read it again", tint: SCPalette.ink) {
                        store.restartPlan(plan)
                    }
                    SCSecondaryButton(title: "Remove from my shelf", tint: SCPalette.ember) {
                        confirmAbandon = true
                    }
                } else {
                    NavigationLink(destination: SCPlanDayView(plan: plan, day: plan.days[s.displayIndex])) {
                        VStack(spacing: 2) {
                            Text("Continue at day \(s.displayIndex + 1)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(SCPalette.card)
                            Text(s.todayComplete ? "Already read" : SCCount.phrase(s.remaining, "day left", "days left"))
                                .font(.system(size: 11.5))
                                .foregroundColor(SCPalette.card.opacity(0.75))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(RoundedRectangle(cornerRadius: 12).fill(SCPalette.ink))
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    HStack(spacing: 8) {
                        SCSecondaryButton(title: "Restart", tint: SCPalette.inkSoft) {
                            confirmRestart = true
                        }
                        SCSecondaryButton(title: "Remove", tint: SCPalette.ember) {
                            confirmAbandon = true
                        }
                    }
                }
            }
        } else {
            SCCard {
                SCPrimaryButton(title: "Start this plan",
                                subtitle: "Day one lands on " + SCDateKey.longString(SCDateKey.today),
                                tint: SCPalette.ink) {
                    store.startPlan(plan)
                }
                Text("More than one plan can run at once. Each keeps its own progress and its own schedule.")
                    .font(type.caption)
                    .foregroundColor(SCPalette.inkFaint)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func behindCard(_ s: SCPlanEngine.Status) -> some View {
        SCCard(tint: SCPalette.emberSoft, stroke: SCPalette.ember.opacity(0.35)) {
            Text(s.daysBehind == 1 ? "One day missed" : "\(s.daysBehind) days missed")
                .font(type.heading)
                .foregroundColor(SCPalette.ember)
            Text("Strict pacing keeps day one pinned to " + SCDateKey.longString(s.startKey) + ". Rebasing moves the whole schedule so the next unread day is today. Days you have already read stay ticked.")
                .font(type.caption)
                .foregroundColor(SCPalette.inkSoft)
                .fixedSize(horizontal: false, vertical: true)
            SCSecondaryButton(title: "Rebase to today", tint: SCPalette.ember) {
                store.rebaseToToday(plan)
            }
            Text("Prefer never to see this again? Switch to flexible pacing in Settings and the plan simply waits for you.")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Day row

    private func dayRow(_ day: SCPlanDay) -> some View {
        let done = store.isDayComplete(plan, day.index)
        let isCurrent = status?.displayIndex == day.index && !(status?.isFinished ?? false)
        let missed = (status?.missedIndices.contains(day.index)) ?? false
        let refs = content.verses(for: day, in: plan).map { $0.shortReference }.joined(separator: "  ")

        return NavigationLink(destination: SCPlanDayView(plan: plan, day: day)) {
            SCCard(tint: isCurrent ? SCPalette.parchmentDeep : SCPalette.card,
                   stroke: isCurrent ? SCPalette.gold.opacity(0.5) : SCPalette.rule,
                   padding: 12) {
                HStack(alignment: .top, spacing: 11) {
                    ZStack {
                        Circle()
                            .fill(done ? SCPalette.sage.opacity(0.16) : Color.clear)
                            .frame(width: 26, height: 26)
                        Circle()
                            .stroke(done ? SCPalette.sage : (missed ? SCPalette.ember.opacity(0.55) : SCPalette.rule),
                                    lineWidth: 1.4)
                            .frame(width: 26, height: 26)
                        if done {
                            SCCheckGlyph(size: 14)
                        } else {
                            Text("\(day.dayNumber)")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(missed ? SCPalette.ember : SCPalette.inkFaint)
                        }
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Day \(day.dayNumber)  |  " + day.title)
                            .font(type.captionStrong)
                            .foregroundColor(SCPalette.ink)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(refs)
                            .font(type.caption)
                            .foregroundColor(SCPalette.inkFaint)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        if let key = store.completionKey(plan, day.index) {
                            Text("Read " + SCDateKey.mediumString(key))
                                .font(type.micro)
                                .foregroundColor(SCPalette.sage)
                        } else if status?.policy == .strict, let p = progress {
                            Text("Scheduled " + SCDateKey.mediumString(SCPlanEngine.scheduledKey(for: day.index, progress: p)))
                                .font(type.micro)
                                .foregroundColor(missed ? SCPalette.ember : SCPalette.inkFaint)
                        }
                    }
                    Spacer(minLength: 0)
                    SCChevronGlyph(size: 13)
                        .padding(.top, 5)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - One day of a plan

struct SCPlanDayView: View {

    let plan: SCPlan
    let day: SCPlanDay

    @EnvironmentObject var store: SCStore
    @Environment(\.presentationMode) private var presentation

    private let content = SCContent.shared
    private var type: SCType { SCType(store.settings.textSize) }

    var body: some View {
        let verses = content.verses(for: day, in: plan)
        let done = store.isDayComplete(plan, day.index)

        SCScreen(title: "Day \(day.dayNumber): " + day.title,
                 subtitle: plan.title,
                 showsBack: true,
                 onBack: { presentation.wrappedValue.dismiss() }) {

            ForEach(verses) { v in
                SCCard {
                    HStack(alignment: .top, spacing: 8) {
                        Text(v.reference)
                            .font(type.reference)
                            .foregroundColor(SCPalette.gold)
                        Spacer(minLength: 0)
                        Button(action: { store.toggleFavourite(v.id) }) {
                            SCBookmarkGlyph(size: 17, filled: store.isFavourite(v.id))
                                .padding(6)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    Text(v.text)
                        .font(type.verse)
                        .foregroundColor(SCPalette.ink)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)
                    if store.settings.showEditorNotes && !v.note.isEmpty {
                        HStack(alignment: .top, spacing: 7) {
                            Rectangle().fill(SCPalette.goldSoft).frame(width: 2)
                            Text(v.note)
                                .font(type.caption)
                                .foregroundColor(SCPalette.inkSoft)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    NavigationLink(destination: SCVerseDetailView(verse: v)) {
                        HStack(spacing: 5) {
                            Text("Open in the library")
                                .font(type.caption)
                                .foregroundColor(SCPalette.inkSoft)
                            SCChevronGlyph(size: 12)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }

            SCCard(tint: SCPalette.parchmentDeep, stroke: SCPalette.goldSoft) {
                Text("Reflection")
                    .font(type.micro)
                    .foregroundColor(SCPalette.gold)
                Text(day.reflection)
                    .font(type.reflection)
                    .foregroundColor(SCPalette.ink)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if done {
                SCCard {
                    HStack(spacing: 8) {
                        SCCheckGlyph(size: 18)
                        Text(readCaption)
                            .font(type.captionStrong)
                            .foregroundColor(SCPalette.sage)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 0)
                    }
                    SCSecondaryButton(title: "Mark as unread", tint: SCPalette.inkSoft) {
                        store.markDay(plan, day.index, read: false)
                    }
                }
            } else if store.isStarted(plan.id) {
                SCPrimaryButton(title: "Mark day \(day.dayNumber) as read", tint: SCPalette.ink) {
                    store.markDay(plan, day.index, read: true)
                }
            } else {
                SCCard {
                    Text("This plan is not running yet.")
                        .font(type.captionStrong)
                        .foregroundColor(SCPalette.ink)
                    Text("Start it from the plan screen and this day becomes tickable.")
                        .font(type.caption)
                        .foregroundColor(SCPalette.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                    SCSecondaryButton(title: "Start this plan") {
                        store.startPlan(plan)
                    }
                }
            }
        }
    }

    private var readCaption: String {
        guard let key = store.completionKey(plan, day.index) else { return "Read" }
        if key == SCDateKey.today { return "Read today" }
        return "Read on " + SCDateKey.longString(key)
    }
}
