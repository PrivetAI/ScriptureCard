import SwiftUI

struct SCLibraryView: View {

    @EnvironmentObject var store: SCStore
    @EnvironmentObject var router: SCRouter

    @State private var query: String = ""
    @FocusState private var searchFocused: Bool

    private let content = SCContent.shared
    private var type: SCType { SCType(store.settings.textSize) }

    var body: some View {
        SCScreen(title: "Library",
                 subtitle: "\(content.verseCount) passages  |  King James Version") {

            searchField

            if !trimmedQuery.isEmpty {
                searchResults
            } else {
                SCSegmented(options: ["Books", "Themes", "Saved"], selection: $router.libraryMode)

                switch router.libraryMode {
                case 1: themeList
                case 2: favouritesList
                default: bookList
                }
            }
        }
    }

    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Search

    private var searchField: some View {
        HStack(spacing: 9) {
            SCSearchGlyph(size: 16)
            TextField("Search a reference or a phrase", text: $query)
                .focused($searchFocused)
                .font(type.body)
                .foregroundColor(SCPalette.ink)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            if !query.isEmpty {
                Button(action: {
                    query = ""
                    searchFocused = false
                }) {
                    SCCloseGlyph(size: 13)
                        .padding(6)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(RoundedRectangle(cornerRadius: 11).fill(SCPalette.card))
        .overlay(
            RoundedRectangle(cornerRadius: 11)
                .stroke(searchFocused ? SCPalette.gold.opacity(0.6) : SCPalette.rule, lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture { searchFocused = true }
    }

    @ViewBuilder
    private var searchResults: some View {
        let hits = content.search(trimmedQuery)
        if hits.isEmpty {
            SCEmptyState(title: "Nothing matched",
                         message: "No passage in the library contains that. Try a shorter phrase, or a reference such as Psalms 23 or John 3.",
                         actionTitle: "Clear the search") {
                query = ""
                searchFocused = false
            }
        } else {
            Text("\(hits.count) " + (hits.count == 1 ? "match" : "matches"))
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)

            ForEach(hits) { v in
                NavigationLink(destination: SCVerseDetailView(verse: v)) {
                    SCCard(padding: 12) {
                        SCVerseRow(verse: v, type: type, favourite: store.isFavourite(v.id))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    // MARK: - Books

    @ViewBuilder
    private var bookList: some View {
        let old = content.books.filter { SCBookOrder.isOldTestament($0) }
        let new = content.books.filter { !SCBookOrder.isOldTestament($0) }

        Text("OLD TESTAMENT  |  \(old.count) BOOKS")
            .font(type.micro)
            .foregroundColor(SCPalette.inkFaint)
            .padding(.top, 4)
        ForEach(old, id: \.self) { book in bookRow(book) }

        Text("NEW TESTAMENT  |  \(new.count) BOOKS")
            .font(type.micro)
            .foregroundColor(SCPalette.inkFaint)
            .padding(.top, 10)
        ForEach(new, id: \.self) { book in bookRow(book) }
    }

    private func bookRow(_ book: String) -> some View {
        let count = content.verses(inBook: book).count
        return NavigationLink(destination: SCBookView(book: book)) {
            SCCard(padding: 12) {
                HStack(spacing: 11) {
                    SCDropCap(letter: String(book.replacingOccurrences(of: " ", with: "").prefix(1)),
                              size: 30,
                              tint: SCPalette.inkFaint)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(book)
                            .font(type.captionStrong)
                            .foregroundColor(SCPalette.ink)
                        Text("\(count) " + (count == 1 ? "passage" : "passages"))
                            .font(type.caption)
                            .foregroundColor(SCPalette.inkFaint)
                    }
                    Spacer(minLength: 0)
                    SCChevronGlyph(size: 13)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Themes

    @ViewBuilder
    private var themeList: some View {
        Text("\(SCTheme.allCases.count) THEMES")
            .font(type.micro)
            .foregroundColor(SCPalette.inkFaint)
            .padding(.top, 4)

        ForEach(SCTheme.allCases, id: \.self) { theme in
            let count = content.count(theme: theme)
            NavigationLink(destination: SCThemeView(theme: theme)) {
                SCCard(padding: 12) {
                    HStack(alignment: .top, spacing: 11) {
                        VStack(alignment: .leading, spacing: 3) {
                            HStack(spacing: 7) {
                                Text(theme.title)
                                    .font(type.captionStrong)
                                    .foregroundColor(SCPalette.ink)
                                SCTagPill(text: "\(count)", tint: SCPalette.themeTint(theme))
                            }
                            Text(theme.blurb)
                                .font(type.caption)
                                .foregroundColor(SCPalette.inkSoft)
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        Spacer(minLength: 0)
                        SCChevronGlyph(size: 13)
                            .padding(.top, 3)
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    // MARK: - Favourites

    @ViewBuilder
    private var favouritesList: some View {
        let favs = store.favouriteVerses
        if favs.isEmpty {
            SCEmptyState(title: "Nothing saved yet",
                         message: "The ribbon on any passage saves it here. Saved passages can also feed the lock screen widget, if you set the widget to show a favorite.",
                         actionTitle: "Browse by theme") {
                router.libraryMode = 1
            }
        } else {
            Text("\(favs.count) SAVED")
                .font(type.micro)
                .foregroundColor(SCPalette.inkFaint)
                .padding(.top, 4)
            ForEach(favs) { v in
                NavigationLink(destination: SCVerseDetailView(verse: v)) {
                    SCCard(padding: 12) {
                        SCVerseRow(verse: v, type: type, favourite: true)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - One book

struct SCBookView: View {
    let book: String

    @EnvironmentObject var store: SCStore
    @Environment(\.presentationMode) private var presentation

    private let content = SCContent.shared
    private var type: SCType { SCType(store.settings.textSize) }

    var body: some View {
        let list = content.verses(inBook: book)
        SCScreen(title: book,
                 subtitle: "\(list.count) passages  |  " + (SCBookOrder.isOldTestament(book) ? "Old Testament" : "New Testament"),
                 showsBack: true,
                 onBack: { presentation.wrappedValue.dismiss() }) {
            if list.isEmpty {
                SCEmptyState(title: "Empty",
                             message: "No passage from this book is in the library.")
            } else {
                ForEach(list) { v in
                    NavigationLink(destination: SCVerseDetailView(verse: v)) {
                        SCCard(padding: 12) {
                            SCVerseRow(verse: v, type: type, favourite: store.isFavourite(v.id))
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

// MARK: - One theme

struct SCThemeView: View {
    let theme: SCTheme

    @EnvironmentObject var store: SCStore
    @Environment(\.presentationMode) private var presentation

    private let content = SCContent.shared
    private var type: SCType { SCType(store.settings.textSize) }

    var body: some View {
        let list = content.verses(theme: theme)
        SCScreen(title: theme.title,
                 subtitle: "\(list.count) passages",
                 showsBack: true,
                 onBack: { presentation.wrappedValue.dismiss() }) {

            SCCard(tint: SCPalette.parchmentDeep, stroke: SCPalette.goldSoft, padding: 13) {
                Text(theme.blurb)
                    .font(type.reflection)
                    .foregroundColor(SCPalette.inkSoft)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if list.isEmpty {
                SCEmptyState(title: "Empty theme",
                             message: "Nothing is tagged with this theme yet.")
            } else {
                ForEach(list) { v in
                    NavigationLink(destination: SCVerseDetailView(verse: v)) {
                        SCCard(padding: 12) {
                            SCVerseRow(verse: v, type: type, favourite: store.isFavourite(v.id))
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}
