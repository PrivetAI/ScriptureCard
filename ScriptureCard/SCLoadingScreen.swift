import SwiftUI

/// Shown while the launch gate is deciding, and again over the panel until its page commits
/// its first frame — the same screen both times, so the handoff has no visible seam.
struct SCLoadingScreen: View {

    @State private var sweep: Double = 0

    var body: some View {
        GeometryReader { geo in
            let w = min(geo.size.width, UIScreen.main.bounds.width)
            ZStack {
                SCPalette.parchment.ignoresSafeArea()

                VStack(spacing: 22) {
                    Spacer(minLength: 0)

                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(SCPalette.card)
                            .frame(width: min(150, w * 0.42), height: min(190, w * 0.53))
                            .shadow(color: SCPalette.shadow, radius: 10, x: 0, y: 5)
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(SCPalette.rule, lineWidth: 1)
                            .frame(width: min(150, w * 0.42), height: min(190, w * 0.53))

                        VStack(spacing: 10) {
                            SCDropCap(letter: "S", size: 40)
                            SCOrnamentRule(width: min(96, w * 0.28))
                            VStack(spacing: 6) {
                                ForEach(0..<3, id: \.self) { i in
                                    Capsule()
                                        .fill(SCPalette.rule.opacity(0.8))
                                        .frame(width: min(96, w * 0.28) - CGFloat(i) * 16, height: 3)
                                }
                            }
                        }
                    }

                    Text("Scripture Card")
                        .font(.system(size: 24, weight: .semibold, design: .serif))
                        .foregroundColor(SCPalette.ink)

                    Text("King James Version, public domain")
                        .font(.system(size: 12.5))
                        .foregroundColor(SCPalette.inkFaint)

                    Spacer(minLength: 0)

                    Canvas { ctx, s in
                        let dotCount = 3
                        let spacing = s.width / CGFloat(dotCount + 1)
                        for i in 0..<dotCount {
                            let phase = (sweep + Double(i) * 0.22).truncatingRemainder(dividingBy: 1.0)
                            let alpha = 0.25 + 0.65 * (1 - abs(phase - 0.5) * 2)
                            let r: CGFloat = 3.5
                            let x = spacing * CGFloat(i + 1)
                            let rect = CGRect(x: x - r, y: s.height / 2 - r, width: r * 2, height: r * 2)
                            ctx.fill(Path(ellipseIn: rect), with: .color(SCPalette.gold.opacity(alpha)))
                        }
                    }
                    .frame(width: 80, height: 16)
                    .padding(.bottom, 44)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 1.4).repeatForever(autoreverses: false)) {
                sweep = 1
            }
        }
    }
}
