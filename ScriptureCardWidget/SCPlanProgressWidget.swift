import SwiftUI
import WidgetKit

struct SCPlanProgressProvider: TimelineProvider {

    func placeholder(in context: Context) -> SCWidgetEntry {
        SCWidgetBuilder.placeholder(preferShort: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SCWidgetEntry) -> Void) {
        let entries = SCWidgetBuilder.timeline(preferShort: false)
        completion(entries.first ?? SCWidgetBuilder.placeholder(preferShort: false))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SCWidgetEntry>) -> Void) {
        let entries = SCWidgetBuilder.timeline(preferShort: false)
        let safe = entries.isEmpty ? [SCWidgetBuilder.placeholder(preferShort: false)] : entries
        completion(Timeline(entries: safe, policy: .after(SCWidgetBuilder.nextReload)))
    }
}

struct SCPlanProgressWidget: Widget {
    let kind = "ScriptureCardPlanWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SCPlanProgressProvider()) { entry in
            SCPlanProgressView(entry: entry)
        }
        .configurationDisplayName("Plan Progress")
        .description("The reading plan you are on, the day you have reached, and whether today has been read.")
        .supportedFamilies([.accessoryCircular,
                            .accessoryRectangular,
                            .accessoryInline,
                            .systemSmall])
    }
}

struct SCPlanProgressView: View {
    @Environment(\.widgetFamily) private var family
    let entry: SCWidgetEntry

    var body: some View {
        switch family {
        case .accessoryCircular: circular
        case .accessoryInline: inline
        case .systemSmall: smallCard
        default: rectangular
        }
    }

    // MARK: - Lock screen

    private var circular: some View {
        ZStack {
            SCWidgetRing(fraction: entry.hasPlan ? entry.planFraction : 1.0,
                         lineWidth: 3.5,
                         track: Color.white.opacity(0.25),
                         tint: Color.white.opacity(0.9))
                .widgetAccentable()
            if entry.hasPlan {
                VStack(spacing: -2) {
                    Text("\(entry.planDay)")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    Text("of \(entry.planTotal)")
                        .font(.system(size: 8.5, weight: .medium))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                .padding(6)
            } else {
                VStack(spacing: -1) {
                    Text(SCBookOrder.abbreviation(for: entry.verse.book))
                        .font(.system(size: 11, weight: .semibold, design: .serif))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    Text("\(entry.verse.chapter):\(entry.verse.verse)")
                        .font(.system(size: 9.5, weight: .medium))
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                .padding(6)
            }
        }
        .widgetURL(URL(string: entry.hasPlan ? "scripturecard://plans" : "scripturecard://today"))
        .scWidgetContainerBackground(Color.clear)
    }

    private var inline: some View {
        Text(inlineText)
            .widgetURL(URL(string: entry.hasPlan ? "scripturecard://plans" : "scripturecard://today"))
            .scWidgetContainerBackground(Color.clear)
    }

    /// The inline slot shares one line with the date and hard-clips the overflow, so this has
    /// to stay near 28 characters. Anything longer is cut mid-word by the system.
    private var inlineText: String {
        if entry.hasPlan, let title = entry.planTitle {
            return SCWidgetText.fit(title, limit: 14) + "  day \(entry.planDay) of \(entry.planTotal)"
        }
        return "Verse  " + entry.verse.shortReference
    }

    private var rectangular: some View {
        VStack(alignment: .leading, spacing: 2) {
            if entry.hasPlan, let title = entry.planTitle {
                Text(SCWidgetText.fit(title, limit: 22))
                    .font(.system(size: 12, weight: .semibold))
                    .widgetAccentable()
                    .lineLimit(1)
                Text("Day \(entry.planDay) of \(entry.planTotal)  |  " + (entry.planRead ? "read" : "not yet read"))
                    .font(.system(size: 11))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text(SCWidgetText.fit(entry.verse.text, limit: 28))
                    .font(.system(size: 11, design: .serif))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            } else {
                Text("Verse of the day")
                    .font(.system(size: 11, weight: .semibold))
                    .widgetAccentable()
                    .lineLimit(1)
                Text(SCWidgetText.fit(entry.verse.text, limit: 48))
                    .font(.system(size: 12, design: .serif))
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .multilineTextAlignment(.leading)
                Text(entry.verse.shortReference)
                    .font(.system(size: 10, weight: .medium))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .widgetURL(URL(string: entry.hasPlan ? "scripturecard://plans" : "scripturecard://today"))
        .scWidgetContainerBackground(Color.clear)
    }

    // MARK: - Home screen

    private var smallCard: some View {
        VStack(alignment: .leading, spacing: 7) {
            if entry.hasPlan, let title = entry.planTitle {
                HStack(alignment: .center, spacing: 9) {
                    ZStack {
                        SCWidgetRing(fraction: entry.planFraction,
                                     lineWidth: 3.5,
                                     track: SCWidgetPalette.rule,
                                     tint: entry.planRead ? SCWidgetPalette.sage : SCWidgetPalette.gold)
                        Text("\(Int((entry.planFraction * 100).rounded()))")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(SCWidgetPalette.ink)
                    }
                    .frame(width: 40, height: 40)

                    VStack(alignment: .leading, spacing: 1) {
                        Text("DAY \(entry.planDay)")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(SCWidgetPalette.gold)
                        Text("of \(entry.planTotal)")
                            .font(.system(size: 9))
                            .foregroundColor(SCWidgetPalette.inkFaint)
                    }
                    Spacer(minLength: 0)
                }

                Text(title)
                    .font(.system(size: 12.5, weight: .semibold, design: .serif))
                    .foregroundColor(SCWidgetPalette.ink)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.leading)

                Text(SCWidgetText.fit(entry.verse.text, limit: 42))
                    .font(.system(size: 10, design: .serif))
                    .foregroundColor(SCWidgetPalette.inkSoft)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)

                Spacer(minLength: 0)

                Text(entry.planRead ? "Read today" : "Not read yet")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(entry.planRead ? SCWidgetPalette.sage : SCWidgetPalette.inkFaint)
                    .lineLimit(1)
            } else {
                Text("NO PLAN RUNNING")
                    .font(.system(size: 8.5, weight: .semibold))
                    .foregroundColor(SCWidgetPalette.gold)
                    .lineLimit(1)

                SCWidgetRule(color: SCWidgetPalette.rule)

                Text(SCWidgetText.fit(entry.verse.text, limit: 96))
                    .font(.system(size: 11, design: .serif))
                    .foregroundColor(SCWidgetPalette.ink)
                    .lineSpacing(1.5)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)

                Text(entry.verse.reference)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(SCWidgetPalette.inkFaint)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .widgetURL(URL(string: entry.hasPlan ? "scripturecard://plans" : "scripturecard://today"))
        .scWidgetContainerBackground(SCWidgetPalette.parchment)
    }
}
