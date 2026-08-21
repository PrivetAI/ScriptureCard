import SwiftUI
import UIKit

struct SCVerseDetailView: View {

    let verse: SCVerse

    @EnvironmentObject var store: SCStore
    @Environment(\.presentationMode) private var presentation

    @State private var copied = false

    private let content = SCContent.shared
    private var type: SCType { SCType(store.settings.textSize) }

    var body: some View {
        SCScreen(title: verse.reference,
                 subtitle: verse.book + "  |  King James Version",
                 showsBack: true,
                 onBack: { presentation.wrappedValue.dismiss() }) {

            SCCard {
                HStack(alignment: .top, spacing: 10) {
                    SCDropCap(letter: String(verse.text.prefix(1)), size: 46)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(verse.reference)
                            .font(type.reference)
                            .foregroundColor(SCPalette.gold)
                        Text("\(verse.wordCount) words")
                            .font(type.micro)
                            .foregroundColor(SCPalette.inkFaint)
                    }
                    Spacer(minLength: 0)
                    Button(action: { store.toggleFavourite(verse.id) }) {
                        SCBookmarkGlyph(size: 20, filled: store.isFavourite(verse.id))
                            .padding(7)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                if store.settings.showOrnaments {
                    SCOrnamentRule()
                }

                Text(verse.text)
                    .font(type.verseLarge)
                    .foregroundColor(SCPalette.ink)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if !verse.note.isEmpty {
                SCCard(tint: SCPalette.parchmentDeep, stroke: SCPalette.goldSoft, padding: 13) {
                    Text("NOTE")
                        .font(type.micro)
                        .foregroundColor(SCPalette.gold)
                    Text(verse.note)
                        .font(type.reflection)
                        .foregroundColor(SCPalette.inkSoft)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            if !verse.themes.isEmpty {
                SCCard(padding: 13) {
                    Text("THEMES")
                        .font(type.micro)
                        .foregroundColor(SCPalette.inkFaint)
                    ForEach(verse.themes, id: \.self) { t in
                        NavigationLink(destination: SCThemeView(theme: t)) {
                            HStack(spacing: 8) {
                                SCTagPill(text: t.title, tint: SCPalette.themeTint(t))
                                Text(t.blurb)
                                    .font(type.caption)
                                    .foregroundColor(SCPalette.inkSoft)
                                    .lineLimit(1)
                                Spacer(minLength: 0)
                                SCChevronGlyph(size: 12)
                            }
                            .padding(.vertical, 3)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }

            planUsageCard

            SCCard(padding: 13) {
                Button(action: copy) {
                    HStack(spacing: 8) {
                        Text(copied ? "Copied to the clipboard" : "Copy the passage")
                            .font(type.captionStrong)
                            .foregroundColor(copied ? SCPalette.sage : SCPalette.ink)
                        Spacer(minLength: 0)
                        if copied { SCCheckGlyph(size: 15) }
                    }
                    .padding(.vertical, 6)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                Rectangle().fill(SCPalette.rule).frame(height: 1)

                NavigationLink(destination: SCBookView(book: verse.book)) {
                    HStack(spacing: 8) {
                        Text("Everything from " + verse.book)
                            .font(type.captionStrong)
                            .foregroundColor(SCPalette.ink)
                        Spacer(minLength: 0)
                        SCChevronGlyph(size: 12)
                    }
                    .padding(.vertical, 6)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }

            Text("King James Version (1611 / 1769), public domain. The note above was written for this app.")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private var planUsageCard: some View {
        let plans = content.plansUsing(ref: verse.id)
        if !plans.isEmpty {
            SCCard(padding: 13) {
                Text("USED IN \(plans.count) " + (plans.count == 1 ? "PLAN" : "PLANS"))
                    .font(type.micro)
                    .foregroundColor(SCPalette.inkFaint)
                ForEach(plans) { p in
                    NavigationLink(destination: SCPlanDetailView(plan: p)) {
                        HStack(spacing: 8) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(p.title)
                                    .font(type.captionStrong)
                                    .foregroundColor(SCPalette.ink)
                                    .multilineTextAlignment(.leading)
                                Text(p.lengthLabel + "  |  " + p.theme.title)
                                    .font(type.caption)
                                    .foregroundColor(SCPalette.inkFaint)
                            }
                            Spacer(minLength: 0)
                            SCChevronGlyph(size: 12)
                        }
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    private func copy() {
        UIPasteboard.general.string = verse.text + "\n" + verse.reference + " (KJV)"
        copied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            copied = false
        }
    }
}
