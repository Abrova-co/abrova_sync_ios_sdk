import SwiftUI
import AbrovaSync

@main
struct AbrovaSyncExampleApp: App {
    init() {
        let builder = AbrovaSyncConfigBuilder(apiKey: AppConfig.apiKey)
            .debugMode(true)
            .offlineEnabled(true)

        // Debug builds can talk to a local server (emulatorHost in Local.plist).
        if let host = AppConfig.emulatorHost {
            _ = builder.useEmulator(host: host)
            print("Using the local Abrova Sync server at \(host)")
        }

        let sync = AbrovaSync.initialize(config: builder.build())

        // With a token provider, `auth.uid` in Security Rules is the user your backend named, and it cannot be
        // forged. Without one the SDK falls back to a client-chosen id, which a project using "Require signed user
        // tokens" refuses - so only wire it up when we can actually mint one.
        if DemoTokenMinter.isConfigured {
            sync.userTokens.provider = { try await DemoTokenMinter.fetchToken() }
            print("Signed user tokens enabled (demo minter)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
