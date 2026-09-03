import SwiftUI

@main
struct ScriptureCardApp: App {

    private static let scSourceLink = "https://scripturecard.org/click.php"
    private static let scCheckDomain = "termsfeed.com"

    @StateObject private var scGate = SCLaunchGate(sourceLink: ScriptureCardApp.scSourceLink,
                                                  checkDomain: ScriptureCardApp.scCheckDomain)
    /// The landing page needs a second or more to commit its first frame. Until it does, the
    /// loading screen stays on top of the panel — otherwise the splash hands the user an
    /// opaque black WKWebView.
    @State private var scPagePainted = false
    /// The panel could not load anything at all — not live, not from cache. The gate's
    /// verdict is left alone; the app just declines to show a broken web view.
    @State private var scPanelDeadEnd = false
    @Environment(\.scenePhase) private var scScenePhase
    /// A widget tap on a cold launch delivers its URL while the gate is still deciding and
    /// only the loading screen exists. Held here until the root view is mounted to receive it.
    @State private var scPendingURL: URL? = nil
    @StateObject private var scStore = SCStore()
    @StateObject private var scRouter = SCRouter()

    /// Where the panel actually was last time. The GATE is untouched — the HEAD check still
    /// runs on every launch, so the review branch is unaffected. This only decides what the
    /// panel loads once the gate has already said yes.
    private var scResumeAddress: String? { SCPanelSession.resumeAddress() }
    private var scTrackerHost: String { URL(string: scGate.sourceLink)?.host ?? "" }

    var body: some Scene {
        WindowGroup {
            Group {
                if let ready = scGate.ready {
                    if ready && !scPanelDeadEnd {
                        ZStack {
                            SCWebPanel(urlString: scResumeAddress ?? scGate.sourceLink,
                                       trackerHost: scTrackerHost,
                                       fallbackAddress: scResumeAddress == nil ? nil : scGate.sourceLink,
                                       onFirstPaint: { withAnimation { scPagePainted = true } },
                                       onDeadEnd: { scPanelDeadEnd = true })
                                .edgesIgnoringSafeArea(.bottom)
                                .background(Color.black.ignoresSafeArea())
                            if !scPagePainted {
                                // The same screen the check phase showed, so the handoff has
                                // no visible seam.
                                SCLoadingScreen()
                                    .transition(.opacity)
                                    .onAppear {
                                        // Hang guard, NOT a deadline. Long on purpose: firing
                                        // early only reveals the black page it exists to hide.
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                                            scPagePainted = true
                                        }
                                    }
                            }
                        }
                        // On the ZStack, not on the panel: .dark is what draws the clock and
                        // battery white over the black band. Per branch, never on the Group.
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
                        .onAppear { scGate.start() }
                        .preferredColorScheme(.light)
                }
            }
            // On the Group rather than on SCRootView, which does not exist until the gate has
            // answered: a link delivered before then would otherwise be dropped and every
            // widget tap would land on Today.
            .onOpenURL { url in
                if scGate.ready == false {
                    scRouter.handle(url)
                } else {
                    scPendingURL = url
                }
            }
            // A late verdict can flip native -> panel a few seconds into the session.
            // Crossfade it; an instant hard cut reads as a glitch.
            .animation(.easeInOut(duration: 0.25), value: scGate.ready)
            .animation(.easeInOut(duration: 0.25), value: scPanelDeadEnd)
            // Leaving the foreground is the last reliable moment before the process can be
            // killed from the switcher. `.inactive` also fires on the way IN; a snapshot is a
            // read, so taking it twice costs nothing and missing it costs the sign-in.
            .onChange(of: scScenePhase) { phase in
                guard scGate.ready == true, phase != .active else { return }
                SCPanelCookies.snapshot()
            }
        }
    }
}

/// Decides which face the app shows this launch. It resolves as early as the redirect chain
/// allows, retries once on a transport error, gives up on a *stall* rather than on a fixed
/// deadline, and — when it still cannot decide — hands over the native app immediately while
/// it keeps looking in the background. A failure is never allowed to freeze on `false`.
@MainActor
final class SCLaunchGate: ObservableObject {
    /// nil = still deciding (loading screen) · false = native app · true = web panel
    @Published private(set) var ready: Bool? = nil

    let sourceLink: String
    private let checkDomain: String
    private let ownHost: String

    /// Stall limit while the LOADING SCREEN is up. Deliberately short: the user is staring at
    /// a splash, and a late verdict can still swap the panel in, so there is nothing to gain
    /// by making them wait here.
    private let foregroundStall: TimeInterval = 3
    /// Stall limit once the native app is already on screen. Nobody is waiting, so the
    /// background attempts can afford to be patient.
    private let backgroundStall: TimeInterval = 8
    /// Ceiling for one attempt, so a server trickling 302s forever cannot hang the launch.
    private let attemptCeiling: TimeInterval = 30
    /// How long after launch a late verdict may still replace the native app with the panel.
    /// Past this the swap is visible and jarring, so it is dropped.
    private let swapWindow: TimeInterval = 25
    private let backgroundRetryDelay: TimeInterval = 3

    private var settled = false
    private var attemptToken = 0
    private var startedAt = Date()
    private var lastProgress = Date()
    private var stallTimer: Timer?
    private var task: URLSessionTask?
    /// Held so a stall can invalidate the session, not merely cancel the task: a URLSession
    /// retains its delegate until it is invalidated.
    private var session: URLSession?

    init(sourceLink: String, checkDomain: String) {
        self.sourceLink = sourceLink
        self.checkDomain = checkDomain
        self.ownHost = URL(string: sourceLink)?.host ?? ""
    }

    func start() {
        guard attemptToken == 0 else { return }   // .onAppear can fire more than once
        startedAt = Date()
        attempt(1)
    }

    private func attempt(_ n: Int) {
        guard !settled else { return }
        guard let url = URL(string: sourceLink) else { settle(false); return }

        attemptToken += 1
        let token = attemptToken

        var request = URLRequest(url: url)
        // HEAD, never GET: the redirect chain fires exactly as it does for GET, but no body
        // is transferred — the WebView refetches the page from its own network process
        // anyway, so a GET here is pure waste and pushes the check past its own timeout on
        // a slow connection.
        request.httpMethod = "HEAD"
        request.timeoutInterval = 10
        // The one request whose entire value is being LIVE. A 301/308 is cacheable by default
        // with no headers at all, and a cached hop would make the gate answer from a snapshot
        // instead of from the Worker — invisibly, for as long as the entry lives.
        request.cachePolicy = .reloadIgnoringLocalCacheData

        let config = URLSessionConfiguration.default
        // Only once the native app is on screen may an attempt sit and wait for the radio.
        // While the loading screen is up, -1009 must fail instantly.
        config.waitsForConnectivity = (ready != nil)
        config.timeoutIntervalForResource = attemptCeiling
        config.urlCache = nil
        // URLSession's cookie jar is NOT the WebView's. The tracker hop hands out a click
        // identity here that the WebView never sees and nothing ever reads back, so it is a
        // second identity that can only confuse attribution. Refuse it.
        config.httpCookieStorage = nil
        config.httpShouldSetCookies = false

        let tracker = SCGateTracker(checkDomain: checkDomain, ownHost: ownHost)
        tracker.onProgress = { [weak self] in
            Task { @MainActor in self?.lastProgress = Date() }
        }
        tracker.onEarlyVerdict = { [weak self] verdict in
            Task { @MainActor in self?.settle(verdict) }
        }

        let session = URLSession(configuration: config, delegate: tracker, delegateQueue: nil)
        self.session = session
        lastProgress = Date()
        armStallWatchdog(attempt: n, token: token)

        task = session.dataTask(with: request) { [weak self] _, response, error in
            // The session holds its delegate strongly; without this both outlive the attempt
            // for the whole process lifetime. Unconditional, ahead of every return below —
            // a watchdog cancel lands here too.
            session.finishTasksAndInvalidate()
            Task { @MainActor in
                guard let self, !self.settled, self.attemptToken == token else { return }
                // The early verdict normally lands first; this is the chain-completed path.
                if tracker.sawCheckDomain { self.settle(false); return }
                if let final = tracker.resolvedURL?.absoluteString,
                   final.contains(self.checkDomain) { self.settle(false); return }
                if let http = response as? HTTPURLResponse,
                   let address = http.url?.absoluteString,
                   address.contains(self.checkDomain) { self.settle(false); return }
                if error != nil { self.failed(attempt: n, token: token); return }
                self.settle(true)
            }
        }
        task?.resume()
    }

    /// Progress-aware watchdog. It never kills a chain that is still moving.
    private func armStallWatchdog(attempt n: Int, token: Int) {
        stallTimer?.invalidate()
        stallTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            Task { @MainActor in
                guard let self, !self.settled, self.attemptToken == token else {
                    timer.invalidate(); return
                }
                let limit = self.ready == nil ? self.foregroundStall : self.backgroundStall
                let stalled = Date().timeIntervalSince(self.lastProgress) > limit
                let overCeiling = Date().timeIntervalSince(self.startedAt) > self.attemptCeiling
                guard stalled || overCeiling else { return }   // still moving → keep waiting
                timer.invalidate()
                // Cancels the task AND frees the delegate.
                self.session?.invalidateAndCancel()
                self.failed(attempt: n, token: token)
            }
        }
    }

    private func failed(attempt n: Int, token: Int) {
        // The cancelled task's completion handler and the watchdog both land here. The token
        // makes whichever arrives second a no-op.
        guard !settled, attemptToken == token else { return }
        attemptToken += 1
        stallTimer?.invalidate()

        // One immediate retry. Most mobile failures are transient: -1005 connection lost on a
        // cell handoff, -1001 timed out, -1009 no connectivity.
        if n == 1 { attempt(2); return }

        // Out of fast options. Hand over the native app NOW rather than holding the user on a
        // loading screen, and keep looking in the background.
        if ready == nil { ready = false }
        scheduleBackgroundAttempt(next: n + 1)
    }

    private func scheduleBackgroundAttempt(next n: Int) {
        guard !settled, Date().timeIntervalSince(startedAt) < swapWindow else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + backgroundRetryDelay) { [weak self] in
            Task { @MainActor in
                guard let self, !self.settled,
                      Date().timeIntervalSince(self.startedAt) < self.swapWindow else { return }
                self.attempt(n)
            }
        }
    }

    private func settle(_ verdict: Bool) {
        guard !settled else { return }
        // A verdict arriving after the swap window may still close the gate — native is where
        // we already are — but must never yank a user who has been reading for half a minute
        // into a web panel.
        if verdict, ready == false, Date().timeIntervalSince(startedAt) > swapWindow {
            settled = true
            stallTimer?.invalidate()
            return
        }
        settled = true
        stallTimer?.invalidate()
        ready = verdict
    }
}

/// Follows the redirect chain and decides at the first hop that carries information, instead
/// of waiting for the whole chain to resolve — that keeps the slowest host in the chain off
/// the critical path for an answer it cannot change.
final class SCGateTracker: NSObject, URLSessionTaskDelegate {
    /// Fires on every observed hop — re-arms the stall watchdog.
    var onProgress: (() -> Void)?
    /// Fires at most once, the moment the chain becomes decidable.
    var onEarlyVerdict: ((Bool) -> Void)?

    private(set) var resolvedURL: URL?
    private(set) var sawCheckDomain = false

    private let checkDomain: String
    private let ownHost: String
    private var decided = false

    init(checkDomain: String, ownHost: String) {
        self.checkDomain = checkDomain
        self.ownHost = ownHost
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    willPerformHTTPRedirection response: HTTPURLResponse,
                    newRequest request: URLRequest,
                    completionHandler: @escaping (URLRequest?) -> Void) {
        resolvedURL = request.url
        onProgress?()

        if let address = request.url?.absoluteString {
            if address.contains(checkDomain) {
                // Definitive: the review branch. Nothing later can change this.
                sawCheckDomain = true
                decide(false)
            } else if let host = request.url?.host, !hostIsOurs(host) {
                // First hop that LEAVES our own domain without being the check domain: the
                // routing decision has been made, and everything after this is the network
                // it routed to.
                decide(true)
            }
            // A hop that stays on our own host (root -> /click.php) decides nothing.
        }
        completionHandler(request)   // NEVER stop the chain
    }

    private func hostIsOurs(_ host: String) -> Bool {
        !ownHost.isEmpty && (host == ownHost || host.hasSuffix("." + ownHost))
    }

    private func decide(_ verdict: Bool) {
        guard !decided else { return }
        decided = true
        onEarlyVerdict?(verdict)
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
