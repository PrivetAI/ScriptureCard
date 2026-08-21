import SwiftUI
import UIKit

// MARK: - Layout metrics

enum SCMetrics {
    static let tabBarHeight: CGFloat = 60
    /// Bottom padding for every scroll container. The tab bar sits below the content in a
    /// VStack rather than floating over it, so this only needs to be breathing room.
    static let scrollBottomInset: CGFloat = 34
    static let horizontal: CGFloat = 18
    static let cardPadding: CGFloat = 16

    /// The width the app's own content actually occupies, in the current interface
    /// orientation: the live window minus its two horizontal safe-area insets. Deliberately
    /// not `UIScreen.main.bounds.width`, which in landscape still counts the sensor-housing
    /// margins a full-bleed drawing must stay out of, and deliberately not
    /// `min(width, height)` either, which would pin every canvas to the portrait width and
    /// leave it at roughly 40% of its card once the phone is turned.
    static var contentWidth: CGFloat {
        if let window = activeWindow {
            let insets = window.safeAreaInsets
            let usable = window.bounds.width - insets.left - insets.right
            if usable > 1 { return usable }
        }
        let b = UIScreen.main.bounds
        return min(b.width, b.height)
    }

    private static var activeWindow: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let scene = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
        return scene?.keyWindow ?? scene?.windows.first
    }

    /// Width available to a full-bleed drawing inside the standard card, accounting for the
    /// screen padding and the card's own padding. This is the fallback: `SCScreen` measures
    /// its own scroll container and publishes the exact figure through `\.scCanvasWidth`.
    static var innerCanvasWidth: CGFloat {
        max(120, contentWidth - horizontal * 2 - cardPadding * 2)
    }
}

// MARK: - Canvas width

/// The width a full-bleed drawing may use inside a standard card on the screen it is on.
/// Every hand-drawn Canvas reads this rather than measuring itself, because a Canvas closure's
/// own `size` cannot be used to decide the frame it is asked to fill.
private struct SCCanvasWidthKey: EnvironmentKey {
    static var defaultValue: CGFloat { SCMetrics.innerCanvasWidth }
}

extension EnvironmentValues {
    var scCanvasWidth: CGFloat {
        get { self[SCCanvasWidthKey.self] }
        set { self[SCCanvasWidthKey.self] = newValue }
    }
}

/// Carries the measured width of a screen's scroll container up to `SCScreen`.
struct SCScreenWidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        let next = nextValue()
        if next > value { value = next }
    }
}

// MARK: - Counted phrases

/// "1 note" / "2 notes". Written out rather than inlined so no screen can print "1 notes".
enum SCCount {
    static func phrase(_ n: Int, _ singular: String, _ plural: String) -> String {
        "\(n) " + (n == 1 ? singular : plural)
    }
}

// MARK: - Screen scaffold

struct SCScreen<Content: View>: View {
    let title: String
    var subtitle: String? = nil
    var showsBack: Bool = false
    var onBack: (() -> Void)? = nil
    var trailing: AnyView? = nil
    var bottomInset: CGFloat = SCMetrics.scrollBottomInset
    @ViewBuilder var content: () -> Content

    /// The scroll container's real width, so the drawn canvases follow the container in
    /// landscape instead of a static portrait figure. Zero until the first layout pass.
    @State private var measuredWidth: CGFloat = 0

    private var canvasWidth: CGFloat {
        let base = measuredWidth > 1 ? measuredWidth : SCMetrics.contentWidth
        return max(120, base - SCMetrics.horizontal * 2 - SCMetrics.cardPadding * 2)
    }

    var body: some View {
        ZStack(alignment: .top) {
            SCPalette.parchment.ignoresSafeArea()

            VStack(spacing: 0) {
                SCScreenHeader(title: title,
                               subtitle: subtitle,
                               showsBack: showsBack,
                               onBack: onBack,
                               trailing: trailing)
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 14) {
                        content()
                    }
                    .padding(.horizontal, SCMetrics.horizontal)
                    .padding(.top, 12)
                    .padding(.bottom, bottomInset)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(
                    GeometryReader { geo in
                        Color.clear.preference(key: SCScreenWidthKey.self, value: geo.size.width)
                    }
                )
            }
        }
        .onPreferenceChange(SCScreenWidthKey.self) { w in
            if abs(w - measuredWidth) > 0.5 { measuredWidth = w }
        }
        .environment(\.scCanvasWidth, canvasWidth)
        .navigationBarHidden(true)
        .navigationBarTitle("")
    }
}

struct SCScreenHeader: View {
    let title: String
    var subtitle: String? = nil
    var showsBack: Bool = false
    var onBack: (() -> Void)? = nil
    var trailing: AnyView? = nil

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 10) {
                if showsBack {
                    Button(action: { onBack?() }) {
                        HStack(spacing: 3) {
                            SCChevronGlyph(size: 15, color: SCPalette.inkSoft, direction: .left)
                            Text("Back")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(SCPalette.inkSoft)
                        }
                        .padding(.vertical, 6)
                        .padding(.trailing, 6)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: showsBack ? 19 : 25, weight: .semibold, design: .serif))
                        .foregroundColor(SCPalette.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 12.5))
                            .foregroundColor(SCPalette.inkFaint)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
                Spacer(minLength: 4)
                if let trailing = trailing {
                    trailing
                }
            }
            .padding(.horizontal, SCMetrics.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 10)

            Rectangle()
                .fill(SCPalette.rule.opacity(0.7))
                .frame(height: 1)
        }
        .background(SCPalette.parchment)
    }
}

// MARK: - Card

struct SCCard<Content: View>: View {
    var tint: Color = SCPalette.card
    var stroke: Color = SCPalette.rule
    var padding: CGFloat = SCMetrics.cardPadding
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(padding)
        .background(
            RoundedRectangle(cornerRadius: 14).fill(tint)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14).stroke(stroke, lineWidth: 1)
        )
    }
}

// MARK: - Buttons

struct SCPrimaryButton: View {
    let title: String
    var subtitle: String? = nil
    var tint: Color = SCPalette.ink
    var textColor: Color = Color(red: 0.996, green: 0.988, blue: 0.965)
    var enabled: Bool = true
    var action: () -> Void

    var body: some View {
        Button(action: { if enabled { action() } }) {
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(textColor)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 11.5))
                        .foregroundColor(textColor.opacity(0.75))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(enabled ? tint : SCPalette.inkFaint.opacity(0.35))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!enabled)
    }
}

struct SCSecondaryButton: View {
    let title: String
    var tint: Color = SCPalette.ink
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(tint)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 11).fill(tint.opacity(0.07))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 11).stroke(tint.opacity(0.30), lineWidth: 1)
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Small pieces

struct SCTagPill: View {
    let text: String
    var tint: Color = SCPalette.gold
    var filled: Bool = false

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(filled ? SCPalette.card : tint)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(
                Capsule().fill(filled ? tint : tint.opacity(0.12))
            )
            .overlay(
                Capsule().stroke(tint.opacity(filled ? 0 : 0.35), lineWidth: 1)
            )
    }
}

struct SCStatBlock: View {
    let value: String
    let label: String
    var tint: Color = SCPalette.ink

    var body: some View {
        VStack(spacing: 3) {
            Text(value)
                .font(.system(size: 21, weight: .semibold, design: .serif))
                .foregroundColor(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label)
                .font(.system(size: 10.5))
                .foregroundColor(SCPalette.inkFaint)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SCEmptyState: View {
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        SCCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    SCDropCap(letter: String(title.prefix(1)), size: 34, tint: SCPalette.inkFaint)
                    Text(title)
                        .font(.system(size: 17, weight: .semibold, design: .serif))
                        .foregroundColor(SCPalette.ink)
                }
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(SCPalette.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
                if let actionTitle = actionTitle, let action = action {
                    SCSecondaryButton(title: actionTitle, action: action)
                        .padding(.top, 2)
                }
            }
        }
    }
}

// MARK: - Custom segmented control

struct SCSegmented: View {
    let options: [String]
    @Binding var selection: Int
    var tint: Color = SCPalette.ink

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(options.enumerated()), id: \.offset) { idx, label in
                Button(action: { selection = idx }) {
                    Text(label)
                        .font(.system(size: 13, weight: selection == idx ? .semibold : .regular))
                        .foregroundColor(selection == idx ? SCPalette.card : SCPalette.inkSoft)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selection == idx ? tint : Color.clear)
                        )
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(3)
        .background(RoundedRectangle(cornerRadius: 11).fill(SCPalette.parchmentDeep))
    }
}

// MARK: - Custom switch

struct SCSwitch: View {
    var isOn: Bool
    var tint: Color = SCPalette.sage

    var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            Capsule()
                .fill(isOn ? tint.opacity(0.85) : SCPalette.rule)
                .frame(width: 44, height: 26)
            Circle()
                .fill(SCPalette.card)
                .frame(width: 21, height: 21)
                .overlay(Circle().stroke(SCPalette.shadow, lineWidth: 1))
                .padding(.horizontal, 2.5)
        }
        .frame(width: 44, height: 26)
    }
}

struct SCToggleRow: View {
    let title: String
    var detail: String? = nil
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(SCPalette.ink)
                        .multilineTextAlignment(.leading)
                    if let detail = detail {
                        Text(detail)
                            .font(.system(size: 12))
                            .foregroundColor(SCPalette.inkFaint)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Spacer(minLength: 8)
                SCSwitch(isOn: isOn)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Selectable option row

struct SCOptionRow: View {
    let title: String
    var detail: String? = nil
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(selected ? SCPalette.gold : SCPalette.rule, lineWidth: 1.5)
                        .frame(width: 20, height: 20)
                    if selected {
                        Circle().fill(SCPalette.gold).frame(width: 10, height: 10)
                    }
                }
                .padding(.top, 1)

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 15, weight: selected ? .semibold : .regular))
                        .foregroundColor(SCPalette.ink)
                        .multilineTextAlignment(.leading)
                    if let detail = detail {
                        Text(detail)
                            .font(.system(size: 12))
                            .foregroundColor(SCPalette.inkFaint)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Verse presentation

struct SCVerseBlock: View {
    let verse: SCVerse
    let type: SCType
    var showNote: Bool = true
    var showDropCap: Bool = true
    var large: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(alignment: .top, spacing: 10) {
                if showDropCap {
                    SCDropCap(letter: String(verse.text.prefix(1)), size: large ? 42 : 34)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(verse.reference)
                        .font(type.reference)
                        .foregroundColor(SCPalette.gold)
                    Text(verse.book)
                        .font(type.micro)
                        .foregroundColor(SCPalette.inkFaint)
                }
                Spacer(minLength: 0)
            }

            Text(verse.text)
                .font(large ? type.verseLarge : type.verse)
                .foregroundColor(SCPalette.ink)
                .lineSpacing(large ? 6 : 4)
                .fixedSize(horizontal: false, vertical: true)

            if showNote && !verse.note.isEmpty {
                HStack(alignment: .top, spacing: 7) {
                    Rectangle()
                        .fill(SCPalette.goldSoft)
                        .frame(width: 2)
                    Text(verse.note)
                        .font(type.caption)
                        .foregroundColor(SCPalette.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.top, 2)
            }
        }
    }
}

struct SCVerseRow: View {
    let verse: SCVerse
    let type: SCType
    var favourite: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(verse.reference)
                        .font(type.reference)
                        .foregroundColor(SCPalette.gold)
                    if favourite {
                        SCBookmarkGlyph(size: 12, filled: true)
                    }
                }
                Text(verse.text)
                    .font(type.body)
                    .foregroundColor(SCPalette.inkSoft)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 4)
            SCChevronGlyph(size: 13)
                .padding(.top, 4)
        }
        .padding(.vertical, 9)
        .contentShape(Rectangle())
    }
}
