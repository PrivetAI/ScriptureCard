import SwiftUI

// Every glyph in the app is drawn here. No SF Symbols, no images, no emoji.

struct SCTodayGlyph: View {
    var size: CGFloat = 24
    var color: Color = SCPalette.ink
    var accent: Color = SCPalette.gold

    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            let lw = max(1.2, w * 0.075)
            let card = CGRect(x: w * 0.13, y: h * 0.16, width: w * 0.74, height: h * 0.68)
            var frame = Path(roundedRect: card, cornerRadius: w * 0.10)
            ctx.stroke(frame, with: .color(color), lineWidth: lw)
            frame = Path()
            frame.move(to: CGPoint(x: card.minX + w * 0.10, y: card.minY + h * 0.22))
            frame.addLine(to: CGPoint(x: card.maxX - w * 0.10, y: card.minY + h * 0.22))
            ctx.stroke(frame, with: .color(color.opacity(0.75)), lineWidth: lw * 0.8)
            var line2 = Path()
            line2.move(to: CGPoint(x: card.minX + w * 0.10, y: card.minY + h * 0.38))
            line2.addLine(to: CGPoint(x: card.maxX - w * 0.24, y: card.minY + h * 0.38))
            ctx.stroke(line2, with: .color(color.opacity(0.55)), lineWidth: lw * 0.8)
            let ribbon = CGRect(x: card.maxX - w * 0.26, y: card.minY - lw * 0.4,
                                width: w * 0.13, height: h * 0.30)
            var rib = Path()
            rib.move(to: CGPoint(x: ribbon.minX, y: ribbon.minY))
            rib.addLine(to: CGPoint(x: ribbon.maxX, y: ribbon.minY))
            rib.addLine(to: CGPoint(x: ribbon.maxX, y: ribbon.maxY))
            rib.addLine(to: CGPoint(x: ribbon.midX, y: ribbon.maxY - ribbon.height * 0.32))
            rib.addLine(to: CGPoint(x: ribbon.minX, y: ribbon.maxY))
            rib.closeSubpath()
            ctx.fill(rib, with: .color(accent))
        }
        .frame(width: size, height: size)
    }
}

struct SCPlansGlyph: View {
    var size: CGFloat = 24
    var color: Color = SCPalette.ink
    var accent: Color = SCPalette.gold

    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            let lw = max(1.2, w * 0.075)
            let rows = 3
            for i in 0..<rows {
                let y = h * (0.24 + 0.26 * Double(i))
                var bar = Path()
                bar.move(to: CGPoint(x: w * 0.42, y: y))
                bar.addLine(to: CGPoint(x: w * 0.86, y: y))
                ctx.stroke(bar, with: .color(color.opacity(i == 2 ? 0.5 : 0.85)), lineWidth: lw)

                if i < 2 {
                    var tick = Path()
                    tick.move(to: CGPoint(x: w * 0.13, y: y))
                    tick.addLine(to: CGPoint(x: w * 0.21, y: y + h * 0.07))
                    tick.addLine(to: CGPoint(x: w * 0.33, y: y - h * 0.10))
                    ctx.stroke(tick, with: .color(accent),
                               style: StrokeStyle(lineWidth: lw, lineCap: .round, lineJoin: .round))
                } else {
                    let dot = Path(ellipseIn: CGRect(x: w * 0.16, y: y - w * 0.07,
                                                     width: w * 0.14, height: w * 0.14))
                    ctx.stroke(dot, with: .color(color.opacity(0.5)), lineWidth: lw * 0.85)
                }
            }
        }
        .frame(width: size, height: size)
    }
}

struct SCLibraryGlyph: View {
    var size: CGFloat = 24
    var color: Color = SCPalette.ink
    var accent: Color = SCPalette.gold

    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            let lw = max(1.2, w * 0.072)
            var left = Path()
            left.move(to: CGPoint(x: w * 0.5, y: h * 0.28))
            left.addCurve(to: CGPoint(x: w * 0.10, y: h * 0.22),
                          control1: CGPoint(x: w * 0.34, y: h * 0.18),
                          control2: CGPoint(x: w * 0.20, y: h * 0.18))
            left.addLine(to: CGPoint(x: w * 0.10, y: h * 0.76))
            left.addCurve(to: CGPoint(x: w * 0.5, y: h * 0.82),
                          control1: CGPoint(x: w * 0.22, y: h * 0.72),
                          control2: CGPoint(x: w * 0.36, y: h * 0.74))
            ctx.stroke(left, with: .color(color),
                       style: StrokeStyle(lineWidth: lw, lineCap: .round, lineJoin: .round))

            var right = Path()
            right.move(to: CGPoint(x: w * 0.5, y: h * 0.28))
            right.addCurve(to: CGPoint(x: w * 0.90, y: h * 0.22),
                           control1: CGPoint(x: w * 0.66, y: h * 0.18),
                           control2: CGPoint(x: w * 0.80, y: h * 0.18))
            right.addLine(to: CGPoint(x: w * 0.90, y: h * 0.76))
            right.addCurve(to: CGPoint(x: w * 0.5, y: h * 0.82),
                           control1: CGPoint(x: w * 0.78, y: h * 0.72),
                           control2: CGPoint(x: w * 0.64, y: h * 0.74))
            ctx.stroke(right, with: .color(color),
                       style: StrokeStyle(lineWidth: lw, lineCap: .round, lineJoin: .round))

            var spine = Path()
            spine.move(to: CGPoint(x: w * 0.5, y: h * 0.28))
            spine.addLine(to: CGPoint(x: w * 0.5, y: h * 0.82))
            ctx.stroke(spine, with: .color(accent), lineWidth: lw * 0.9)
        }
        .frame(width: size, height: size)
    }
}

struct SCHistoryGlyph: View {
    var size: CGFloat = 24
    var color: Color = SCPalette.ink
    var accent: Color = SCPalette.gold

    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            let cell = w * 0.20
            let gap = w * 0.07
            let originX = (w - (cell * 3 + gap * 2)) / 2
            let originY = (h - (cell * 3 + gap * 2)) / 2
            let filled: Set<Int> = [0, 2, 4, 5, 7]
            for r in 0..<3 {
                for c in 0..<3 {
                    let i = r * 3 + c
                    let rect = CGRect(x: originX + Double(c) * (cell + gap),
                                      y: originY + Double(r) * (cell + gap),
                                      width: cell, height: cell)
                    let p = Path(roundedRect: rect, cornerRadius: cell * 0.28)
                    if filled.contains(i) {
                        ctx.fill(p, with: .color(i == 4 ? accent : color.opacity(0.8)))
                    } else {
                        ctx.stroke(p, with: .color(color.opacity(0.4)), lineWidth: max(1, w * 0.05))
                    }
                }
            }
        }
        .frame(width: size, height: size)
    }
}

struct SCSettingsGlyph: View {
    var size: CGFloat = 24
    var color: Color = SCPalette.ink
    var accent: Color = SCPalette.gold

    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            let lw = max(1.2, w * 0.072)
            let ys = [h * 0.27, h * 0.5, h * 0.73]
            let knobX = [w * 0.68, w * 0.34, w * 0.58]
            for (i, y) in ys.enumerated() {
                var line = Path()
                line.move(to: CGPoint(x: w * 0.13, y: y))
                line.addLine(to: CGPoint(x: w * 0.87, y: y))
                ctx.stroke(line, with: .color(color.opacity(0.65)),
                           style: StrokeStyle(lineWidth: lw, lineCap: .round))
                let r = w * 0.10
                let knob = Path(ellipseIn: CGRect(x: knobX[i] - r, y: y - r, width: r * 2, height: r * 2))
                ctx.fill(knob, with: .color(SCPalette.card))
                ctx.stroke(knob, with: .color(i == 1 ? accent : color), lineWidth: lw)
            }
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Small utility glyphs

struct SCCheckGlyph: View {
    var size: CGFloat = 16
    var color: Color = SCPalette.sage
    var lineWidthFactor: CGFloat = 0.14

    var body: some View {
        Canvas { ctx, s in
            var p = Path()
            p.move(to: CGPoint(x: s.width * 0.18, y: s.height * 0.53))
            p.addLine(to: CGPoint(x: s.width * 0.42, y: s.height * 0.76))
            p.addLine(to: CGPoint(x: s.width * 0.83, y: s.height * 0.24))
            ctx.stroke(p, with: .color(color),
                       style: StrokeStyle(lineWidth: s.width * lineWidthFactor,
                                          lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

struct SCChevronGlyph: View {
    enum Direction { case left, right, up, down }
    var size: CGFloat = 14
    var color: Color = SCPalette.inkFaint
    var direction: Direction = .right

    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            var p = Path()
            switch direction {
            case .right:
                p.move(to: CGPoint(x: w * 0.36, y: h * 0.2))
                p.addLine(to: CGPoint(x: w * 0.68, y: h * 0.5))
                p.addLine(to: CGPoint(x: w * 0.36, y: h * 0.8))
            case .left:
                p.move(to: CGPoint(x: w * 0.64, y: h * 0.2))
                p.addLine(to: CGPoint(x: w * 0.32, y: h * 0.5))
                p.addLine(to: CGPoint(x: w * 0.64, y: h * 0.8))
            case .up:
                p.move(to: CGPoint(x: w * 0.2, y: h * 0.64))
                p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.32))
                p.addLine(to: CGPoint(x: w * 0.8, y: h * 0.64))
            case .down:
                p.move(to: CGPoint(x: w * 0.2, y: h * 0.36))
                p.addLine(to: CGPoint(x: w * 0.5, y: h * 0.68))
                p.addLine(to: CGPoint(x: w * 0.8, y: h * 0.36))
            }
            ctx.stroke(p, with: .color(color),
                       style: StrokeStyle(lineWidth: w * 0.13, lineCap: .round, lineJoin: .round))
        }
        .frame(width: size, height: size)
    }
}

struct SCBookmarkGlyph: View {
    var size: CGFloat = 18
    var filled: Bool = false
    var color: Color = SCPalette.gold

    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            var p = Path()
            p.move(to: CGPoint(x: w * 0.26, y: h * 0.14))
            p.addLine(to: CGPoint(x: w * 0.74, y: h * 0.14))
            p.addLine(to: CGPoint(x: w * 0.74, y: h * 0.87))
            p.addLine(to: CGPoint(x: w * 0.50, y: h * 0.66))
            p.addLine(to: CGPoint(x: w * 0.26, y: h * 0.87))
            p.closeSubpath()
            if filled {
                ctx.fill(p, with: .color(color))
            } else {
                ctx.stroke(p, with: .color(color),
                           style: StrokeStyle(lineWidth: w * 0.10, lineJoin: .round))
            }
        }
        .frame(width: size, height: size)
    }
}

struct SCSearchGlyph: View {
    var size: CGFloat = 16
    var color: Color = SCPalette.inkFaint

    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            let lw = w * 0.12
            let r = w * 0.30
            let c = CGPoint(x: w * 0.42, y: h * 0.42)
            let circle = Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2))
            ctx.stroke(circle, with: .color(color), lineWidth: lw)
            var tail = Path()
            tail.move(to: CGPoint(x: c.x + r * 0.72, y: c.y + r * 0.72))
            tail.addLine(to: CGPoint(x: w * 0.86, y: h * 0.86))
            ctx.stroke(tail, with: .color(color), style: StrokeStyle(lineWidth: lw, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

struct SCCloseGlyph: View {
    var size: CGFloat = 14
    var color: Color = SCPalette.inkSoft

    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            var p = Path()
            p.move(to: CGPoint(x: w * 0.24, y: h * 0.24))
            p.addLine(to: CGPoint(x: w * 0.76, y: h * 0.76))
            p.move(to: CGPoint(x: w * 0.76, y: h * 0.24))
            p.addLine(to: CGPoint(x: w * 0.24, y: h * 0.76))
            ctx.stroke(p, with: .color(color),
                       style: StrokeStyle(lineWidth: w * 0.12, lineCap: .round))
        }
        .frame(width: size, height: size)
    }
}

struct SCFlameGlyph: View {
    var size: CGFloat = 18
    var color: Color = SCPalette.ember

    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            var p = Path()
            p.move(to: CGPoint(x: w * 0.5, y: h * 0.10))
            p.addCurve(to: CGPoint(x: w * 0.83, y: h * 0.58),
                       control1: CGPoint(x: w * 0.66, y: h * 0.26),
                       control2: CGPoint(x: w * 0.83, y: h * 0.38))
            p.addCurve(to: CGPoint(x: w * 0.17, y: h * 0.58),
                       control1: CGPoint(x: w * 0.83, y: h * 0.86),
                       control2: CGPoint(x: w * 0.17, y: h * 0.86))
            p.addCurve(to: CGPoint(x: w * 0.5, y: h * 0.10),
                       control1: CGPoint(x: w * 0.17, y: h * 0.36),
                       control2: CGPoint(x: w * 0.38, y: h * 0.30))
            p.closeSubpath()
            ctx.fill(p, with: .color(color.opacity(0.22)))
            ctx.stroke(p, with: .color(color), lineWidth: w * 0.085)
            var inner = Path()
            inner.move(to: CGPoint(x: w * 0.5, y: h * 0.42))
            inner.addCurve(to: CGPoint(x: w * 0.63, y: h * 0.66),
                           control1: CGPoint(x: w * 0.58, y: h * 0.50),
                           control2: CGPoint(x: w * 0.63, y: h * 0.56))
            inner.addCurve(to: CGPoint(x: w * 0.37, y: h * 0.66),
                           control1: CGPoint(x: w * 0.63, y: h * 0.80),
                           control2: CGPoint(x: w * 0.37, y: h * 0.80))
            inner.addCurve(to: CGPoint(x: w * 0.5, y: h * 0.42),
                           control1: CGPoint(x: w * 0.37, y: h * 0.56),
                           control2: CGPoint(x: w * 0.44, y: h * 0.50))
            inner.closeSubpath()
            ctx.fill(inner, with: .color(color))
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Ornaments

/// A drawn rule with a small diamond at the centre. Used as the header divider on cards.
struct SCOrnamentRule: View {
    /// Left nil, the rule spans the card it sits in, as measured by the enclosing `SCScreen`.
    var width: CGFloat? = nil
    var color: Color = SCPalette.rule
    var accent: Color = SCPalette.gold

    @Environment(\.scCanvasWidth) private var canvasWidth

    var body: some View {
        Canvas { ctx, s in
            let w = s.width, h = s.height
            let midY = h / 2
            let gap = min(18, w * 0.12)
            var left = Path()
            left.move(to: CGPoint(x: 0, y: midY))
            left.addLine(to: CGPoint(x: w / 2 - gap, y: midY))
            var right = Path()
            right.move(to: CGPoint(x: w / 2 + gap, y: midY))
            right.addLine(to: CGPoint(x: w, y: midY))
            ctx.stroke(left, with: .color(color), lineWidth: 1)
            ctx.stroke(right, with: .color(color), lineWidth: 1)
            var dia = Path()
            let r = min(4.5, h / 2)
            dia.move(to: CGPoint(x: w / 2, y: midY - r))
            dia.addLine(to: CGPoint(x: w / 2 + r, y: midY))
            dia.addLine(to: CGPoint(x: w / 2, y: midY + r))
            dia.addLine(to: CGPoint(x: w / 2 - r, y: midY))
            dia.closeSubpath()
            ctx.fill(dia, with: .color(accent))
        }
        .frame(width: max(1, width ?? canvasWidth), height: 12)
    }
}

/// A drop-cap style initial in a ruled box, drawn rather than typeset.
struct SCDropCap: View {
    var letter: String
    var size: CGFloat = 40
    var tint: Color = SCPalette.gold

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.16)
                .fill(tint.opacity(0.12))
            RoundedRectangle(cornerRadius: size * 0.16)
                .stroke(tint.opacity(0.45), lineWidth: 1)
            Text(letter.uppercased())
                .font(.system(size: size * 0.56, weight: .semibold, design: .serif))
                .foregroundColor(tint)
        }
        .frame(width: size, height: size)
    }
}

/// Progress ring drawn with Canvas, used on plan cards.
struct SCProgressRing: View {
    var fraction: Double
    var size: CGFloat = 42
    var lineWidth: CGFloat = 4
    var track: Color = SCPalette.rule
    var tint: Color = SCPalette.gold
    var label: String? = nil
    var labelColor: Color = SCPalette.ink

    var body: some View {
        ZStack {
            Canvas { ctx, s in
                let inset = lineWidth / 2
                let rect = CGRect(x: inset, y: inset,
                                  width: max(1, s.width - lineWidth),
                                  height: max(1, s.height - lineWidth))
                let circle = Path(ellipseIn: rect)
                ctx.stroke(circle, with: .color(track), lineWidth: lineWidth)
                let f = min(1, max(0, fraction))
                if f > 0.001 {
                    var arc = Path()
                    arc.addArc(center: CGPoint(x: s.width / 2, y: s.height / 2),
                               radius: max(1, (min(s.width, s.height) - lineWidth) / 2),
                               startAngle: .degrees(-90),
                               endAngle: .degrees(-90 + 360 * f),
                               clockwise: false)
                    ctx.stroke(arc, with: .color(tint),
                               style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                }
            }
            if let label = label {
                Text(label)
                    .font(.system(size: size * 0.30, weight: .semibold))
                    .foregroundColor(labelColor)
            }
        }
        .frame(width: size, height: size)
    }
}
