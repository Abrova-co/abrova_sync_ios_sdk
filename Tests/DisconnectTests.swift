import XCTest
@testable import AbrovaSync

/// `disconnect()` tells the app at once. Found 2026-10-26 in the Flutter example on the iOS Simulator: the closed socket
/// is released and never reports closing, so the app kept showing "Connected" (and Disconnect seemed to do nothing)
/// while the SDK was offline and queueing every write.
final class DisconnectTests: XCTestCase {
    private final class Recorder: AbrovaSyncDelegate {
        var disconnects = 0
        func abrovaSync(_ abrovaSync: AbrovaSync, didDisconnectWithError error: Error?) { disconnects += 1 }
    }

    func testDisconnectTellsTheDelegateAndGoesOffline() {
        let sync = AbrovaSync.initialize(config: AbrovaSyncConfigBuilder(apiKey: "ab_live_test").offlineEnabled(true).build())
        let recorder = Recorder()
        sync.delegate = recorder

        sync.disconnect()

        XCTAssertEqual(recorder.disconnects, 1)
        XCTAssertEqual(sync.syncState, .offline)
    }
}
