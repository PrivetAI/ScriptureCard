import SwiftUI
import WidgetKit

struct SCVerseCardProvider: TimelineProvider {

    func placeholder(in context: Context) -> SCWidgetEntry {
        SCWidgetBuilder.placeholder(preferShort: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (SCWidgetEntry) -> Void) {
        let entries = SCWidgetBuilder.timeline(preferShort: true)
        completion(entries.first ?? SCWidgetBuilder.placeholder(preferShort: true))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SCWidgetEntry>) -> Void) {
        let entries = SCWidgetBuilder.timeline(preferShort: true)
        let safe = entries.isEmpty ? [SCWidgetBuilder.placeholder(preferShort: true)] : entries
        completion(Timeline(entries: safe, policy: .after(SCWidgetBuilder.nextReload)))
    }
}

struct SCVerseCardWidget: Widget {
    let kind = "ScriptureCardVerseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SCVerseCardProvider()) { entry in
            SCVerseCardView(entry: entry)
        }
        .configurationDisplayName("Verse Card")
        .description("A passage from the King James Version, chosen by the date or by the plan you are reading.")
        .supportedFamilies([.accessoryRectangular,
                            .accessoryInline,
                            .accessoryCircular,
                            .systemSmall,
                            .systemMedium])
    }
}

struct SCVerseCardView: View {
    @Environment(\.widgetFamily) private var family
    let entry: SCWidgetEntry

    var body: some View {
        switch family {
        case .accessoryRectangular: rectangular
        case .accessoryInline: inline
        case .accessoryCircular: circular
        case .systemMedium: mediumCard
        default: smallCard
        }
    }

    // MARK: - Lock screen

    private var rectangular: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.verse.shortReference)
                .font(.system(size: 11, weight: .semibold))
                .widgetAccentable()
                .lineLimit(1)
            Text(SCWidgetText.fit(entry.verse.text, limit: 72))
                .font(.system(size: 12.5, design: .serif))
                .lineLimit(3)
                .minimumScaleFactor(0.85)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .widgetURL(URL(string: "scripturecard://today"))
        .scWidgetContainerBackground(Color.clear)
    }

    /// Reference only. The inline slot shares one line with the date and clips whatever does
    /// not fit, mid-word and without an ellipsis of our own, so no verse text goes here.
    private var inline: some View {
        Text(entry.verse.shortReference)
            .widgetURL(URL(string: "scripturecard://library"))
            .scWidgetContainerBackground(Color.clear)
    }

    private var circular: some View {
        ZStack {
            SCWidgetRing(fraction: 1.0,
                         lineWidth: 3,
                         track: Color.white.opacity(0.25),
                         tint: Color.white.opacity(0.85))
                .widgetAccentable()
            VStack(spacing: -1) {
                Text(bookAbbreviation)
                    .font(.system(size: 12, weight: .semibold, design: .serif))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                Text("\(entry.verse.chapter):\(entry.verse.verse)")
                    .font(.system(size: 10, weight: .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .padding(6)
        }
        .widgetURL(URL(string: "scripturecard://library"))
        .scWidgetContainerBackground(Color.clear)
    }

    private var bookAbbreviation: String {
        SCBookOrder.abbreviation(for: entry.verse.book)
    }

    // MARK: - Home screen

    private var smallCard: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(entry.verse.reference.uppercased())
                .font(.system(size: 8.5, weight: .semibold))
                .foregroundColor(SCWidgetPalette.gold)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            SCWidgetRule(color: SCWidgetPalette.rule)

            Text(SCWidgetText.fit(entry.verse.text, limit: 100))
                .font(.system(size: 11.5, design: .serif))
                .foregroundColor(SCWidgetPalette.ink)
                .lineSpacing(1.5)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 0)

            Text("King James Version")
                .font(.system(size: 7.5))
                .foregroundColor(SCWidgetPalette.inkFaint)
                .lineLimit(1)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .widgetURL(URL(string: "scripturecard://today"))
        .scWidgetContainerBackground(SCWidgetPalette.parchment)
    }

    private var mediumCard: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(SCWidgetPalette.gold.opacity(0.12))
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(SCWidgetPalette.gold.opacity(0.45), lineWidth: 1)
                    Text(String(entry.verse.text.prefix(1)).uppercased())
                        .font(.system(size: 22, weight: .semibold, design: .serif))
                        .foregroundColor(SCWidgetPalette.gold)
                }
                .frame(width: 40, height: 40)
                Text(SCBookOrder.abbreviation(for: entry.verse.book))
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundColor(SCWidgetPalette.inkFaint)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Spacer(minLength: 0)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(entry.verse.reference.uppercased())
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(SCWidgetPalette.gold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(SCWidgetText.fit(entry.verse.text, limit: 205))
                    .font(.system(size: 12.5, design: .serif))
                    .foregroundColor(SCWidgetPalette.ink)
                    .lineSpacing(2)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 0)

                Text(footerText)
                    .font(.system(size: 8.5))
                    .foregroundColor(SCWidgetPalette.inkFaint)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
        }
        .padding(13)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .widgetURL(URL(string: "scripturecard://today"))
        .scWidgetContainerBackground(SCWidgetPalette.parchment)
    }

    private var footerText: String {
        if entry.hasPlan, let title = entry.planTitle {
            return title + "  |  day \(entry.planDay) of \(entry.planTotal)"
        }
        return "King James Version, public domain"
    }
}
