import SwiftUI

/// Fixed colours. Nothing here reads the device appearance, so the app looks identical
/// whatever the phone's light/dark setting is.
enum SCPalette {
    static let parchment   = Color(red: 0.965, green: 0.945, blue: 0.906)
    static let parchmentDeep = Color(red: 0.929, green: 0.898, blue: 0.839)
    static let card        = Color(red: 0.996, green: 0.988, blue: 0.965)
    static let ink         = Color(red: 0.106, green: 0.157, blue: 0.224)
    static let inkSoft     = Color(red: 0.325, green: 0.376, blue: 0.443)
    static let inkFaint    = Color(red: 0.573, green: 0.612, blue: 0.667)
    static let gold        = Color(red: 0.722, green: 0.537, blue: 0.169)
    static let goldSoft    = Color(red: 0.878, green: 0.796, blue: 0.616)
    static let ember       = Color(red: 0.698, green: 0.259, blue: 0.180)
    static let emberSoft   = Color(red: 0.925, green: 0.847, blue: 0.824)
    static let rule        = Color(red: 0.847, green: 0.812, blue: 0.741)
    static let sage        = Color(red: 0.365, green: 0.478, blue: 0.416)
    static let shadow      = Color.black.opacity(0.06)

    static func themeTint(_ theme: SCTheme) -> Color {
        switch theme {
        case .hope, .praise, .thanksgiving: return gold
        case .fear, .doubt, .discipline: return ember
        case .rest, .mercy, .love: return sage
        default: return ink
        }
    }
}

/// Type ramp. Every size passes through the user's reading-size setting.
struct SCType {
    let scale: Double

    init(_ size: SCTextSize) { scale = size.scale }

    private func f(_ base: CGFloat, _ weight: Font.Weight, serif: Bool) -> Font {
        let pt = base * CGFloat(scale)
        if serif {
            return Font.system(size: pt, weight: weight, design: .serif)
        }
        return Font.system(size: pt, weight: weight, design: .default)
    }

    var display: Font { f(27, .semibold, serif: true) }
    var title: Font { f(21, .semibold, serif: true) }
    var heading: Font { f(17, .semibold, serif: true) }
    var verse: Font { f(18, .regular, serif: true) }
    var verseLarge: Font { f(21, .regular, serif: true) }
    var body: Font { f(15.5, .regular, serif: false) }
    var reflection: Font { f(15.5, .regular, serif: true) }
    var caption: Font { f(12.5, .regular, serif: false) }
    var captionStrong: Font { f(12.5, .semibold, serif: false) }
    var micro: Font { f(10.5, .semibold, serif: false) }
    var button: Font { f(16, .semibold, serif: false) }
    var reference: Font { f(13.5, .semibold, serif: false) }
}
