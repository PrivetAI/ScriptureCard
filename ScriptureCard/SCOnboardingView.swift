import SwiftUI

/// Shown once on first launch and re-openable from Settings. Four cards, stepped by hand
/// so no system pager is involved.
struct SCOnboardingView: View {

    let onFinish: () -> Void

    @State private var step: Int = 0

    private struct Page {
        let title: String
        let body: String
        let footnote: String
    }

    private let pages: [Page] = [
        Page(title: "A plan, not a shuffle",
             body: "Scripture Card is built around reading plans. You pick one, read a day at a time, and tick the day off. The daily card on the Today tab is there whether or not a plan is running, but the plans are the point.",
             footnote: "Twenty-six plans, from seven days to forty."),
        Page(title: "Missing days is expected",
             body: "Life interrupts. Choose flexible pacing and a plan simply waits for you, taking as long as it takes. Choose strict pacing and day one stays pinned to your start date, so the app can tell you how far behind you are, and rebase the whole schedule to today in one tap.",
             footnote: "The setting lives in Settings and applies to every plan."),
        Page(title: "King James, public domain",
             body: "Every passage is King James Version, first printed in 1611. It is in the public domain, which is why the whole library works offline with nothing to sign in to. Each passage carries a one-line note written for this app, and each plan day carries a short reflection.",
             footnote: "No modern translation is included, by design."),
        Page(title: "On your lock screen",
             body: "Two widgets are available. Verse Card puts a passage under the clock. Plan Progress shows a ring with the day you are on and whether today has been read. Touch and hold the lock screen, tap Customize, then add a widget under the clock.",
             footnote: "Everything you do stays on this device.")
    ]

    var body: some View {
        GeometryReader { geo in
            let w = min(geo.size.width, UIScreen.main.bounds.width)
            let compact = geo.size.height < 700
            // Roughly the height the scroll view is given once the Skip row and the pager and
            // buttons below it have taken their share. Used only as a minimum so the card is
            // centred on a tall phone instead of hugging the top; it still scrolls if longer.
            let scrollMinHeight = max(0, geo.size.height - 44 - (compact ? 128 : 150))

            ZStack {
                SCPalette.parchment.ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Spacer(minLength: 0)
                        Button(action: onFinish) {
                            Text("Skip")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(SCPalette.inkFaint)
                                .padding(10)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 10)
                    .padding(.top, 4)

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: compact ? 14 : 20) {
                            SCOnboardingArt(step: step, width: min(w - 72, 260), compact: compact)
                                .padding(.top, compact ? 4 : 10)

                            VStack(spacing: 10) {
                                Text(currentPage.title)
                                    .font(.system(size: compact ? 22 : 26, weight: .semibold, design: .serif))
                                    .foregroundColor(SCPalette.ink)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)

                                SCOrnamentRule(width: min(160, w * 0.45))

                                Text(currentPage.body)
                                    .font(.system(size: compact ? 14.5 : 15.5))
                                    .foregroundColor(SCPalette.inkSoft)
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(3)
                                    .fixedSize(horizontal: false, vertical: true)

                                Text(currentPage.footnote)
                                    .font(.system(size: 11.5))
                                    .foregroundColor(SCPalette.inkFaint)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.horizontal, 26)
                        }
                        .frame(maxWidth: .infinity, minHeight: scrollMinHeight, alignment: .center)
                        .padding(.bottom, 12)
                    }
                    .frame(maxHeight: .infinity)

                    VStack(spacing: 12) {
                        HStack(spacing: 7) {
                            ForEach(0..<pages.count, id: \.self) { i in
                                Capsule()
                                    .fill(i == step ? SCPalette.gold : SCPalette.rule)
                                    .frame(width: i == step ? 20 : 7, height: 7)
                            }
                        }

                        HStack(spacing: 10) {
                            if step > 0 {
                                SCSecondaryButton(title: "Back", tint: SCPalette.inkSoft) {
                                    if step > 0 { step -= 1 }
                                }
                                .frame(width: min(120, w * 0.32))
                            }
                            SCPrimaryButton(title: step == pages.count - 1 ? "Start reading" : "Next") {
                                if step < pages.count - 1 {
                                    step += 1
                                } else {
                                    onFinish()
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 22)
                    .padding(.bottom, compact ? 16 : 28)
                    .padding(.top, 8)
                }
            }
        }
    }

    private var currentPage: Page {
        let idx = min(max(0, step), pages.count - 1)
        return pages[idx]
    }
}

/// One drawn illustration per onboarding page. All Canvas, no images.
struct SCOnboardingArt: View {
    let step: Int
    let width: CGFloat
    var compact: Bool = false

    var body: some View {
        let h = compact ? width * 0.52 : width * 0.62
        Canvas { ctx, size in
            var g = ctx
            let w = size.width
            let hh = size.height
            switch step {
            case 0: drawPlanCards(&g, w, hh)
            case 1: drawCalendar(&g, w, hh)
            case 2: drawBook(&g, w, hh)
            default: drawLockScreen(&g, w, hh)
            }
        }
        .frame(width: width, height: h)
    }

    private func drawPlanCards(_ ctx: inout GraphicsContext, _ w: CGFloat, _ h: CGFloat) {
        let cardW = w * 0.42
        let cardH = h * 0.78
        for i in 0..<3 {
            let offset = CGFloat(i) * w * 0.13
            let rect = CGRect(x: w * 0.10 + offset,
                              y: h * 0.16 - CGFloat(2 - i) * h * 0.04,
                              width: cardW, height: cardH)
            let path = Path(roundedRect: rect, cornerRadius: 10)
            ctx.fill(path, with: .color(i == 2 ? SCPalette.card : SCPalette.parchmentDeep))
            ctx.stroke(path, with: .color(i == 2 ? SCPalette.gold.opacity(0.6) : SCPalette.rule), lineWidth: 1)
            if i == 2 {
                for line in 0..<4 {
                    var p = Path()
                    let y = rect.minY + cardH * (0.24 + 0.16 * CGFloat(line))
                    p.move(to: CGPoint(x: rect.minX + 12, y: y))
                    p.addLine(to: CGPoint(x: rect.maxX - 12 - CGFloat(line) * 6, y: y))
                    ctx.stroke(p, with: .color(SCPalette.rule), lineWidth: 2)
                }
                var tick = Path()
                tick.move(to: CGPoint(x: rect.minX + 14, y: rect.maxY - 22))
                tick.addLine(to: CGPoint(x: rect.minX + 22, y: rect.maxY - 14))
                tick.addLine(to: CGPoint(x: rect.minX + 36, y: rect.maxY - 32))
                ctx.stroke(tick, with: .color(SCPalette.gold),
                           style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            }
        }
    }

    private func drawCalendar(_ ctx: inout GraphicsContext, _ w: CGFloat, _ h: CGFloat) {
        let cols = 7
        let rows = 4
        let gap = w * 0.022
        let cell = (w * 0.82 - gap * CGFloat(cols - 1)) / CGFloat(cols)
        let originX = w * 0.09
        let originY = h * 0.16
        let filled: Set<Int> = [0, 1, 2, 4, 5, 7, 8, 9, 12, 14, 15, 16, 17, 21, 22]
        let missed: Set<Int> = [3, 6, 10]
        for r in 0..<rows {
            for c in 0..<cols {
                let i = r * cols + c
                let rect = CGRect(x: originX + CGFloat(c) * (cell + gap),
                                  y: originY + CGFloat(r) * (cell + gap),
                                  width: cell, height: cell)
                let path = Path(roundedRect: rect, cornerRadius: cell * 0.25)
                if filled.contains(i) {
                    ctx.fill(path, with: .color(SCPalette.gold.opacity(0.85)))
                } else if missed.contains(i) {
                    ctx.fill(path, with: .color(SCPalette.emberSoft))
                    ctx.stroke(path, with: .color(SCPalette.ember.opacity(0.55)), lineWidth: 1)
                } else {
                    ctx.fill(path, with: .color(SCPalette.parchmentDeep))
                    ctx.stroke(path, with: .color(SCPalette.rule), lineWidth: 0.8)
                }
            }
        }
        var arrow = Path()
        let y = originY + CGFloat(rows) * (cell + gap) + h * 0.06
        arrow.move(to: CGPoint(x: originX, y: y))
        arrow.addLine(to: CGPoint(x: originX + w * 0.72, y: y))
        arrow.move(to: CGPoint(x: originX + w * 0.72 - 9, y: y - 6))
        arrow.addLine(to: CGPoint(x: originX + w * 0.72, y: y))
        arrow.addLine(to: CGPoint(x: originX + w * 0.72 - 9, y: y + 6))
        ctx.stroke(arrow, with: .color(SCPalette.inkFaint),
                   style: StrokeStyle(lineWidth: 1.6, lineCap: .round, lineJoin: .round))
    }

    private func drawBook(_ ctx: inout GraphicsContext, _ w: CGFloat, _ h: CGFloat) {
        var left = Path()
        left.move(to: CGPoint(x: w * 0.5, y: h * 0.28))
        left.addCurve(to: CGPoint(x: w * 0.12, y: h * 0.24),
                      control1: CGPoint(x: w * 0.34, y: h * 0.16),
                      control2: CGPoint(x: w * 0.22, y: h * 0.17))
        left.addLine(to: CGPoint(x: w * 0.12, y: h * 0.80))
        left.addCurve(to: CGPoint(x: w * 0.5, y: h * 0.86),
                      control1: CGPoint(x: w * 0.24, y: h * 0.76),
                      control2: CGPoint(x: w * 0.36, y: h * 0.78))
        left.closeSubpath()
        ctx.fill(left, with: .color(SCPalette.card))
        ctx.stroke(left, with: .color(SCPalette.rule), lineWidth: 1.4)

        var right = Path()
        right.move(to: CGPoint(x: w * 0.5, y: h * 0.28))
        right.addCurve(to: CGPoint(x: w * 0.88, y: h * 0.24),
                       control1: CGPoint(x: w * 0.64, y: h * 0.16),
                       control2: CGPoint(x: w * 0.78, y: h * 0.17))
        right.addLine(to: CGPoint(x: w * 0.88, y: h * 0.80))
        right.addCurve(to: CGPoint(x: w * 0.5, y: h * 0.86),
                       control1: CGPoint(x: w * 0.76, y: h * 0.76),
                       control2: CGPoint(x: w * 0.64, y: h * 0.78))
        right.closeSubpath()
        ctx.fill(right, with: .color(SCPalette.card))
        ctx.stroke(right, with: .color(SCPalette.rule), lineWidth: 1.4)

        for i in 0..<5 {
            let y = h * (0.36 + 0.10 * CGFloat(i))
            var l = Path()
            l.move(to: CGPoint(x: w * 0.18, y: y))
            l.addLine(to: CGPoint(x: w * 0.44, y: y))
            ctx.stroke(l, with: .color(SCPalette.rule), lineWidth: 1.6)
            var r = Path()
            r.move(to: CGPoint(x: w * 0.56, y: y))
            r.addLine(to: CGPoint(x: w * 0.82 - CGFloat(i) * 5, y: y))
            ctx.stroke(r, with: .color(SCPalette.rule), lineWidth: 1.6)
        }

        var ribbon = Path()
        ribbon.move(to: CGPoint(x: w * 0.46, y: h * 0.28))
        ribbon.addLine(to: CGPoint(x: w * 0.54, y: h * 0.28))
        ribbon.addLine(to: CGPoint(x: w * 0.54, y: h * 0.98))
        ribbon.addLine(to: CGPoint(x: w * 0.50, y: h * 0.90))
        ribbon.addLine(to: CGPoint(x: w * 0.46, y: h * 0.98))
        ribbon.closeSubpath()
        ctx.fill(ribbon, with: .color(SCPalette.gold))
    }

    private func drawLockScreen(_ ctx: inout GraphicsContext, _ w: CGFloat, _ h: CGFloat) {
        let phone = CGRect(x: w * 0.30, y: h * 0.06, width: w * 0.40, height: h * 0.88)
        let body = Path(roundedRect: phone, cornerRadius: phone.width * 0.16)
        ctx.fill(body, with: .color(SCPalette.ink))
        ctx.stroke(body, with: .color(SCPalette.inkSoft), lineWidth: 1)

        let inner = phone.insetBy(dx: phone.width * 0.06, dy: phone.height * 0.04)
        let screen = Path(roundedRect: inner, cornerRadius: inner.width * 0.13)
        ctx.fill(screen, with: .color(SCPalette.inkSoft.opacity(0.55)))

        let clock = Text("9:41")
            .font(.system(size: max(9, inner.width * 0.20), weight: .semibold, design: .rounded))
            .foregroundColor(SCPalette.card)
        ctx.draw(clock, at: CGPoint(x: inner.midX, y: inner.minY + inner.height * 0.20), anchor: .center)

        let widget = CGRect(x: inner.minX + inner.width * 0.08,
                            y: inner.minY + inner.height * 0.34,
                            width: inner.width * 0.84,
                            height: inner.height * 0.20)
        let wPath = Path(roundedRect: widget, cornerRadius: 6)
        ctx.fill(wPath, with: .color(SCPalette.card.opacity(0.92)))
        for i in 0..<3 {
            var l = Path()
            let y = widget.minY + widget.height * (0.28 + 0.24 * CGFloat(i))
            l.move(to: CGPoint(x: widget.minX + 6, y: y))
            l.addLine(to: CGPoint(x: widget.maxX - 6 - CGFloat(i) * 8, y: y))
            ctx.stroke(l, with: .color(i == 2 ? SCPalette.gold : SCPalette.inkFaint), lineWidth: 1.6)
        }

        let ringCenter = CGPoint(x: inner.midX, y: inner.minY + inner.height * 0.72)
        let radius = inner.width * 0.16
        let track = Path(ellipseIn: CGRect(x: ringCenter.x - radius, y: ringCenter.y - radius,
                                           width: radius * 2, height: radius * 2))
        ctx.stroke(track, with: .color(SCPalette.card.opacity(0.35)), lineWidth: 3)
        var arc = Path()
        arc.addArc(center: ringCenter, radius: radius,
                   startAngle: .degrees(-90), endAngle: .degrees(130), clockwise: false)
        ctx.stroke(arc, with: .color(SCPalette.gold),
                   style: StrokeStyle(lineWidth: 3, lineCap: .round))
    }
}
