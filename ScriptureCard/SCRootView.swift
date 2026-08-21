import SwiftUI

struct SCRootView: View {

    @EnvironmentObject var store: SCStore
    @EnvironmentObject var router: SCRouter

    var body: some View {
        ZStack {
            SCPalette.parchment.ignoresSafeArea()

            VStack(spacing: 0) {
                Group {
                    switch router.tab {
                    case 0:
                        NavigationView { SCTodayView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 1:
                        NavigationView { SCPlansView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 2:
                        NavigationView { SCLibraryView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    case 3:
                        NavigationView { SCHistoryView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    default:
                        NavigationView { SCSettingsView() }
                            .navigationViewStyle(StackNavigationViewStyle())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                SCTabBar(selection: $router.tab)
            }

            if !store.settings.onboardingSeen {
                SCOnboardingView(onFinish: { store.markOnboardingSeen() })
                    .transition(.opacity)
                    .zIndex(10)
            }
        }
    }
}

struct SCTabBar: View {
    @Binding var selection: Int

    private let labels = ["Today", "Plans", "Library", "History", "Settings"]

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(SCPalette.rule.opacity(0.8))
                .frame(height: 1)

            HStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { i in
                    Button(action: { selection = i }) {
                        VStack(spacing: 3) {
                            glyph(for: i, active: selection == i)
                            Text(labels[i])
                                .font(.system(size: 9.5, weight: selection == i ? .semibold : .regular))
                                .foregroundColor(selection == i ? SCPalette.ink : SCPalette.inkFaint)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(height: SCMetrics.tabBarHeight)
        }
        .background(SCPalette.card.edgesIgnoringSafeArea(.bottom))
    }

    @ViewBuilder
    private func glyph(for index: Int, active: Bool) -> some View {
        let tint = active ? SCPalette.ink : SCPalette.inkFaint
        let accent = active ? SCPalette.gold : SCPalette.inkFaint.opacity(0.6)
        switch index {
        case 0: SCTodayGlyph(size: 23, color: tint, accent: accent)
        case 1: SCPlansGlyph(size: 23, color: tint, accent: accent)
        case 2: SCLibraryGlyph(size: 23, color: tint, accent: accent)
        case 3: SCHistoryGlyph(size: 23, color: tint, accent: accent)
        default: SCSettingsGlyph(size: 23, color: tint, accent: accent)
        }
    }
}
