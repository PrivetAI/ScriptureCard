import SwiftUI

struct SCPlansView: View {

    @EnvironmentObject var store: SCStore
    @State private var shelf: Int = 3
    @State private var sortByLength: Bool = false

    private let content = SCContent.shared
    private var type: SCType { SCType(store.settings.textSize) }

    var body: some View {
        SCScreen(title: "Plans",
                 subtitle: "\(content.planCount) plans  |  \(totalAuthoredDays) authored days") {

            SCSegmented(options: SCPlanLibrary.Shelf.allCases.map { $0.title }, selection: $shelf)

            Text(currentShelf.caption)
                .font(type.caption)
                .foregroundColor(SCPalette.inkFaint)

            if !activePairs.isEmpty {
                sectionTitle("Running now")
                ForEach(Array(activePairs.enumerated()), id: \.offset) { _, pair in
                    planCard(plan: pair.0, progress: pair.1)
                }
            }

            if !finishedPairs.isEmpty {
                sectionTitle("Completed")
                ForEach(Array(finishedPairs.enumerated()), id: \.offset) { _, pair in
                    planCard(plan: pair.0, progress: pair.1)
                }
            }

            sectionTitle(activePairs.isEmpty && finishedPairs.isEmpty ? "All plans" : "More to start")

            if shelfPlans.isEmpty {
                SCEmptyState(title: "Nothing on this shelf",
                             message: "Every plan of this length has already been started. Switch the filter above to see the rest.",
                             actionTitle: "Show everything") {
                    shelf = 3
                }
            } else {
                ForEach(shelfPlans) { plan in
                    planCard(plan: plan, progress: store.progress(for: plan.id))
                }
            }

            Button(action: { sortByLength.toggle() }) {
                Text(sortByLength ? "Sorted by length. Sort by theme instead." : "Sorted by theme. Sort by length instead.")
                    .font(type.caption)
                    .foregroundColor(SCPalette.inkSoft)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 10)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private var currentShelf: SCPlanLibrary.Shelf {
        SCPlanLibrary.Shelf(rawValue: shelf) ?? .all
    }

    private var totalAuthoredDays: Int {
        content.plans.reduce(0) { $0 + $1.length }
    }

    private var activePairs: [(SCPlan, SCPlanProgress)] {
        store.activeProgress.compactMap { p in
            guard let plan = content.plan(id: p.planID) else { return nil }
            return (plan, p)
        }
    }

    private var finishedPairs: [(SCPlan, SCPlanProgress)] {
        store.finishedProgress.compactMap { p in
            guard let plan = content.plan(id: p.planID) else { return nil }
            return (plan, p)
        }
    }

    private var shelfPlans: [SCPlan] {
        let started = Set(store.state.progress.map { $0.planID })
        var list = content.plans.filter { currentShelf.matches($0) && !started.contains($0.id) }
        if sortByLength {
            list.sort { a, b in
                if a.length != b.length { return a.length < b.length }
                return a.title < b.title
            }
        } else {
            list.sort { a, b in
                if a.theme.title != b.theme.title { return a.theme.title < b.theme.title }
                return a.title < b.title
            }
        }
        return list
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text.uppercased())
            .font(type.micro)
            .foregroundColor(SCPalette.inkFaint)
            .padding(.top, 8)
    }

    private func planCard(plan: SCPlan, progress: SCPlanProgress?) -> some View {
        let status: SCPlanEngine.Status? = progress.map {
            SCPlanEngine.status(plan: plan, progress: $0, policy: store.settings.catchUp)
        }
        return NavigationLink(destination: SCPlanDetailView(plan: plan)) {
            SCCard {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(plan.title)
                            .font(type.heading)
                            .foregroundColor(SCPalette.ink)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(plan.subtitle)
                            .font(type.caption)
                            .foregroundColor(SCPalette.inkFaint)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer(minLength: 4)
                    if let s = status {
                        SCProgressRing(fraction: s.fraction,
                                       size: 40,
                                       lineWidth: 3.5,
                                       tint: s.isFinished ? SCPalette.sage : SCPalette.gold,
                                       label: s.isFinished ? nil : s.percentText)
                    } else {
                        SCChevronGlyph(size: 14)
                            .padding(.top, 6)
                    }
                }

                Text(plan.summary)
                    .font(type.caption)
                    .foregroundColor(SCPalette.inkSoft)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 6) {
                    SCTagPill(text: plan.lengthLabel, tint: SCPalette.ink)
                    SCTagPill(text: plan.theme.title, tint: SCPalette.gold)
                    if let s = status {
                        if s.isFinished {
                            SCTagPill(text: "Completed", tint: SCPalette.sage, filled: true)
                        } else if s.policy == .strict && s.daysBehind > 0 {
                            SCTagPill(text: "\(s.daysBehind) behind", tint: SCPalette.ember)
                        } else {
                            SCTagPill(text: s.headline, tint: SCPalette.sage)
                        }
                    }
                    Spacer(minLength: 0)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
