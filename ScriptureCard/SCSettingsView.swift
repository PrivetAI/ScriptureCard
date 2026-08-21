import SwiftUI

struct SCSettingsView: View {

    @EnvironmentObject var store: SCStore
    @EnvironmentObject var router: SCRouter

    @State private var showPrivacy = false
    @State private var confirmReset = false

    private let content = SCContent.shared
    private var type: SCType { SCType(store.settings.textSize) }

    /// Read from the bundle so it cannot drift from the shipped version on the next bump.
    private var appVersion: String {
        (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "1.0"
    }

    var body: some View {
        SCScreen(title: "Settings",
                 subtitle: "Everything stays on this device") {

            pacingCard
            widgetCard
            readingCard
            displayCard
            translationCard
            aboutCard
            resetCard

            Text("Scripture Card, version " + appVersion)
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 6)
        }
        .sheet(isPresented: $showPrivacy) {
            SCWebPanel(urlString: "https://example.com")
        }
    }

    // MARK: - Pacing

    private var pacingCard: some View {
        SCCard {
            Text("CATCH-UP POLICY")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
            Text("What happens to a plan when you miss a day.")
                .font(type.caption)
                .foregroundColor(SCPalette.inkSoft)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(SCCatchUpPolicy.allCases, id: \.self) { policy in
                SCOptionRow(title: policy.title,
                            detail: policy.explanation,
                            selected: store.settings.catchUp == policy) {
                    store.setCatchUp(policy)
                }
                .padding(.vertical, 4)
            }

            Text("The setting applies to every plan at once and can be changed as often as you like. Nothing is deleted when you switch.")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Widget

    private var widgetCard: some View {
        SCCard {
            Text("LOCK SCREEN WIDGET")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
            Text("What the widget shows when more than one thing is available.")
                .font(type.caption)
                .foregroundColor(SCPalette.inkSoft)
                .fixedSize(horizontal: false, vertical: true)

            ForEach(SCWidgetContent.allCases, id: \.self) { mode in
                SCOptionRow(title: mode.title,
                            detail: mode.detail,
                            selected: store.settings.widgetContent == mode) {
                    store.setWidgetContent(mode)
                }
                .padding(.vertical, 4)
            }

            Rectangle().fill(SCPalette.rule).frame(height: 1)

            Text("To add it: touch and hold the lock screen, tap Customize, choose the lock screen, tap the area under the clock and pick Scripture Card. The Verse Card and Plan Progress widgets are both offered, and both also work on the home screen.")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Reading

    private var readingCard: some View {
        SCCard {
            Text("READING TEXT SIZE")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)

            SCSegmented(options: SCTextSize.allCases.map { $0.title },
                        selection: Binding(
                            get: { SCTextSize.allCases.firstIndex(of: store.settings.textSize) ?? 1 },
                            set: { idx in
                                let all = SCTextSize.allCases
                                if idx >= 0 && idx < all.count { store.setTextSize(all[idx]) }
                            }))

            Text("For God so loved the world, that he gave his only begotten Son.")
                .font(type.verse)
                .foregroundColor(SCPalette.ink)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 2)
            Text("A sample line at the size you have chosen. The setting applies everywhere in the app.")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Display

    private var displayCard: some View {
        SCCard {
            Text("DISPLAY")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)

            SCToggleRow(title: "Show the short notes",
                        detail: "The one-line context line written for each passage.",
                        isOn: store.settings.showEditorNotes) {
                store.setShowEditorNotes(!store.settings.showEditorNotes)
            }
            .padding(.vertical, 4)

            Rectangle().fill(SCPalette.rule).frame(height: 1)

            SCToggleRow(title: "Drawn ornaments",
                        detail: "The ruled dividers and drop capitals on cards.",
                        isOn: store.settings.showOrnaments) {
                store.setShowOrnaments(!store.settings.showOrnaments)
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Translation

    private var translationCard: some View {
        SCCard(tint: SCPalette.parchmentDeep, stroke: SCPalette.goldSoft) {
            Text("TRANSLATION")
                .font(type.micro)
                .foregroundColor(SCPalette.gold)
            Text("King James Version (1611 / 1769)")
                .font(type.heading)
                .foregroundColor(SCPalette.ink)
            Text("Public domain worldwide. This is the only translation in the app, and it cannot be changed.")
                .font(type.caption)
                .foregroundColor(SCPalette.inkSoft)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 6) {
                SCTagPill(text: "\(content.verseCount) passages", tint: SCPalette.ink)
                SCTagPill(text: "\(content.planCount) plans", tint: SCPalette.gold)
                Spacer(minLength: 0)
            }
        }
    }

    // MARK: - About and privacy

    private var aboutCard: some View {
        SCCard(padding: 13) {
            NavigationLink(destination: SCAboutView()) {
                settingsLinkRow("About this app", "Why the King James Version, and how the plan engine works")
            }
            .buttonStyle(PlainButtonStyle())

            Rectangle().fill(SCPalette.rule).frame(height: 1)

            Button(action: { showPrivacy = true }) {
                settingsLinkRow("Privacy Policy", "Opens in an in-app browser")
            }
            .buttonStyle(PlainButtonStyle())

            Rectangle().fill(SCPalette.rule).frame(height: 1)

            Button(action: {
                store.replayOnboarding()
                router.tab = 0
            }) {
                settingsLinkRow("Show the introduction again", "The four cards from the first launch")
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private func settingsLinkRow(_ title: String, _ detail: String) -> some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(type.captionStrong)
                    .foregroundColor(SCPalette.ink)
                    .multilineTextAlignment(.leading)
                Text(detail)
                    .font(type.micro)
                    .foregroundColor(SCPalette.inkFaint)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
            SCChevronGlyph(size: 13)
        }
        .padding(.vertical, 7)
        .contentShape(Rectangle())
    }

    // MARK: - Reset

    @ViewBuilder
    private var resetCard: some View {
        if confirmReset {
            SCCard(tint: SCPalette.emberSoft, stroke: SCPalette.ember.opacity(0.45)) {
                Text("Reset all progress")
                    .font(type.heading)
                    .foregroundColor(SCPalette.ember)
                Text("This clears every plan you have started, every tick, every saved passage, every note and the whole reading history. Your preferences on this screen are kept. It cannot be undone.")
                    .font(type.caption)
                    .foregroundColor(SCPalette.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                SCPrimaryButton(title: "Erase everything", tint: SCPalette.ember) {
                    store.resetEverything()
                    confirmReset = false
                    router.tab = 0
                }
                SCSecondaryButton(title: "Keep everything", tint: SCPalette.inkSoft) {
                    confirmReset = false
                }
            }
        } else {
            SCCard(padding: 13) {
                Button(action: { confirmReset = true }) {
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Reset all progress")
                                .font(type.captionStrong)
                                .foregroundColor(SCPalette.ember)
                            Text(SCCount.phrase(store.daysRead, "day", "days")
                                 + ", " + SCCount.phrase(store.state.progress.count, "plan", "plans")
                                 + ", " + "\(store.state.favourites.count) saved"
                                 + ", " + SCCount.phrase(store.journalEntries.count, "note", "notes"))
                                .font(type.micro)
                                .foregroundColor(SCPalette.inkFaint)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer(minLength: 0)
                        SCChevronGlyph(size: 13, color: SCPalette.ember.opacity(0.7))
                    }
                    .padding(.vertical, 7)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - About

struct SCAboutView: View {

    @EnvironmentObject var store: SCStore
    @Environment(\.presentationMode) private var presentation

    private let content = SCContent.shared
    private var type: SCType { SCType(store.settings.textSize) }

    var body: some View {
        SCScreen(title: "About",
                 subtitle: "Scripture Card",
                 showsBack: true,
                 onBack: { presentation.wrappedValue.dismiss() }) {

            aboutBlock("Why the King James Version",
                       "The King James Version, first printed in 1611 and standardized in 1769, is in the public domain everywhere. That means it can be included in full, quoted at length and read offline without a license. Modern translations are under copyright and cannot be shipped this way. The trade is real: the King James English is four centuries old, and some words have drifted. Where that matters, the short note under a passage says so.")

            aboutBlock("What the plan engine does",
                       "A plan is an ordered sequence of days. Starting one records the date. From then on the app tracks each day separately, so more than one plan can run at once without interfering. Completion is stored per day with the date it happened, which is why the history view can be rebuilt from scratch and why a restarted plan keeps its earlier run in your totals.")

            aboutBlock("Strict and flexible",
                       "Under flexible pacing, day N arrives only when day N minus one is done, so a missed day simply makes the plan longer and nothing is ever marked as missed. Under strict pacing, day one is pinned to the date you started and the calendar keeps moving, so the app can tell you how far behind you are. Rebasing re-pins the schedule to today and keeps every day you have already read.")

            aboutBlock("What is stored",
                       "Everything is kept on this device. There is no account, no sign-in and no server. The only thing sent anywhere is a single check at launch. Your notes never leave the phone, and clearing progress in Settings really does erase them.")

            SCCard(tint: SCPalette.parchmentDeep, stroke: SCPalette.goldSoft) {
                Text("IN THIS VERSION")
                    .font(type.micro)
                    .foregroundColor(SCPalette.gold)
                HStack(spacing: 6) {
                    SCStatBlock(value: "\(content.verseCount)", label: "Passages")
                    SCStatBlock(value: "\(content.planCount)", label: "Plans")
                    SCStatBlock(value: "\(content.plans.reduce(0) { $0 + $1.length })", label: "Authored days")
                    SCStatBlock(value: "\(SCTheme.allCases.count)", label: "Themes")
                }
                Text("Every reflection and every short note was written for this app. The scripture text itself is unaltered King James Version.")
                    .font(type.micro)
                    .foregroundColor(SCPalette.inkFaint)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text("Scripture Card is a reading tool. It takes no position on any question of doctrine and belongs to no denomination.")
                .font(type.caption)
                .foregroundColor(SCPalette.inkFaint)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
        }
    }

    private func aboutBlock(_ title: String, _ body: String) -> some View {
        SCCard {
            Text(title)
                .font(type.heading)
                .foregroundColor(SCPalette.ink)
                .fixedSize(horizontal: false, vertical: true)
            if store.settings.showOrnaments {
                SCOrnamentRule()
            }
            Text(body)
                .font(type.reflection)
                .foregroundColor(SCPalette.inkSoft)
                .lineSpacing(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
