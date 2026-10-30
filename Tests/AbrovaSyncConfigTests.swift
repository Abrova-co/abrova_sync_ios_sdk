import XCTest
@testable import AbrovaSync

/// Comprehensive tests for AbrovaSyncConfig and AbrovaSyncConfigBuilder
final class AbrovaSyncConfigTests: XCTestCase {

    // MARK: - Valid API Key Formats

    func testBuilderAcceptsValidLiveApiKey() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123xyz789")
            .build()

        XCTAssertEqual(config.apiKey, "ab_live_abc123xyz789")
    }

    func testBuilderAcceptsValidTestApiKey() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123xyz789")
            .build()

        XCTAssertEqual(config.apiKey, "ab_live_abc123xyz789")
    }

    func testBuilderAcceptsLongApiKey() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abcdefghijklmnop")
            .build()

        XCTAssertEqual(config.apiKey, "ab_live_abcdefghijklmnop")
    }

    // MARK: - Default Values

    func testBuilderSetsCorrectDefaultValues() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .build()

        XCTAssertFalse(config.debugMode)
        XCTAssertTrue(config.autoReconnect)
        XCTAssertFalse(config.offlineEnabled)
        XCTAssertEqual(config.offlineCacheSizeMb, 100)
        XCTAssertTrue(config.syncOnReconnect)
        XCTAssertEqual(config.conflictStrategy, .serverWins)
        XCTAssertNil(config.conflictResolver)
        XCTAssertEqual(config.maxSyncRetries, 3)
    }

    // MARK: - debugMode

    func testDebugModeCanBeEnabled() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .debugMode(true)
            .build()

        XCTAssertTrue(config.debugMode)
    }

    func testDebugModeCanBeDisabled() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .debugMode(true)
            .debugMode(false) // Override
            .build()

        XCTAssertFalse(config.debugMode)
    }

    // MARK: - autoReconnect

    func testAutoReconnectCanBeDisabled() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .autoReconnect(false)
            .build()

        XCTAssertFalse(config.autoReconnect)
    }

    func testAutoReconnectCanBeEnabledExplicitly() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .autoReconnect(true)
            .build()

        XCTAssertTrue(config.autoReconnect)
    }

    // MARK: - offlineEnabled

    func testOfflineEnabledCanBeEnabled() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .offlineEnabled(true)
            .build()

        XCTAssertTrue(config.offlineEnabled)
    }

    func testOfflineEnabledDefaultsToFalse() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .build()

        XCTAssertFalse(config.offlineEnabled)
    }

    // MARK: - offlineCacheSizeMb

    func testOfflineCacheSizeMbAcceptsValidPositiveValue() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .offlineCacheSizeMb(50)
            .build()

        XCTAssertEqual(config.offlineCacheSizeMb, 50)
    }

    func testOfflineCacheSizeMbAcceptsLargeValue() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .offlineCacheSizeMb(500)
            .build()

        XCTAssertEqual(config.offlineCacheSizeMb, 500)
    }

    func testOfflineCacheSizeMbDefaultValue() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .build()

        XCTAssertEqual(config.offlineCacheSizeMb, 100)
    }

    // MARK: - syncOnReconnect

    func testSyncOnReconnectCanBeDisabled() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .syncOnReconnect(false)
            .build()

        XCTAssertFalse(config.syncOnReconnect)
    }

    func testSyncOnReconnectDefaultsToTrue() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .build()

        XCTAssertTrue(config.syncOnReconnect)
    }

    // MARK: - conflictStrategy

    func testConflictStrategyServerWins() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .conflictStrategy(.serverWins)
            .build()

        XCTAssertEqual(config.conflictStrategy, .serverWins)
    }

    func testConflictStrategyClientWins() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .conflictStrategy(.clientWins)
            .build()

        XCTAssertEqual(config.conflictStrategy, .clientWins)
    }

    func testConflictStrategyMerge() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .conflictStrategy(.merge)
            .build()

        XCTAssertEqual(config.conflictStrategy, .merge)
    }

    func testConflictStrategyManual() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .conflictStrategy(.manual)
            .build()

        XCTAssertEqual(config.conflictStrategy, .manual)
    }

    func testConflictStrategyDefaultsToServerWins() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .build()

        XCTAssertEqual(config.conflictStrategy, .serverWins)
    }

    // MARK: - maxSyncRetries

    func testMaxSyncRetriesAcceptsPositiveValue() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .maxSyncRetries(5)
            .build()

        XCTAssertEqual(config.maxSyncRetries, 5)
    }

    func testMaxSyncRetriesDefaultValue() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .build()

        XCTAssertEqual(config.maxSyncRetries, 3)
    }

    // MARK: - Endpoints (fixed, always encrypted)

    func testEndpointsAreFixedAndEncrypted() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123").build()

        XCTAssertEqual(config.apiUrl, "https://sync.abrova.ir")
        XCTAssertEqual(config.mqttHost, "mqtt-sync.abrova.ir")
        XCTAssertEqual(config.mqttPort, 8885)
        XCTAssertTrue(config.mqttUseTls)
    }

    // MARK: - Connection Settings

    func testConnectionTimeoutCanBeSet() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .connectionTimeout(60)
            .build()

        XCTAssertEqual(config.connectionTimeout, 60)
    }

    func testKeepAliveIntervalCanBeSet() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .keepAliveInterval(120)
            .build()

        XCTAssertEqual(config.keepAliveInterval, 120)
    }

    func testReconnectIntervalCanBeSet() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .reconnectInterval(10.0)
            .build()

        XCTAssertEqual(config.reconnectInterval, 10.0, accuracy: 0.001)
    }

    // MARK: - Builder Method Chaining

    func testBuilderMethodChaining() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123")
            .debugMode(true)
            .autoReconnect(false)
            .offlineEnabled(true)
            .offlineCacheSizeMb(200)
            .syncOnReconnect(false)
            .conflictStrategy(.clientWins)
            .maxSyncRetries(5)
            .connectionTimeout(45)
            .build()

        XCTAssertEqual(config.apiKey, "ab_live_abc123")
        XCTAssertTrue(config.debugMode)
        XCTAssertFalse(config.autoReconnect)
        XCTAssertTrue(config.offlineEnabled)
        XCTAssertEqual(config.offlineCacheSizeMb, 200)
        XCTAssertFalse(config.syncOnReconnect)
        XCTAssertEqual(config.conflictStrategy, .clientWins)
        XCTAssertEqual(config.maxSyncRetries, 5)
        XCTAssertEqual(config.connectionTimeout, 45)
    }

    // MARK: - Direct Init

    func testDirectInitWithAllParameters() {
        let config = AbrovaSyncConfig(
            apiKey: "ab_live_xyz789",
            debugMode: true,
            autoReconnect: false,
            reconnectInterval: 10,
            connectionTimeout: 60,
            keepAliveInterval: 120,
            offlineEnabled: true,
            offlineCacheSizeMb: 250,
            syncOnReconnect: false,
            conflictStrategy: .merge,
            conflictResolver: nil,
            maxSyncRetries: 7
        )

        XCTAssertEqual(config.apiKey, "ab_live_xyz789")
        XCTAssertTrue(config.debugMode)
        XCTAssertFalse(config.autoReconnect)
        XCTAssertEqual(config.reconnectInterval, 10)
        XCTAssertEqual(config.connectionTimeout, 60)
        XCTAssertEqual(config.keepAliveInterval, 120)
        XCTAssertTrue(config.offlineEnabled)
        XCTAssertEqual(config.offlineCacheSizeMb, 250)
        XCTAssertFalse(config.syncOnReconnect)
        XCTAssertEqual(config.conflictStrategy, .merge)
        XCTAssertEqual(config.maxSyncRetries, 7)
    }

    // MARK: - mqttServerUri

    func testMqttServerUriIsAlwaysEncrypted() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123").build()

        XCTAssertEqual(config.mqttServerUri, "mqtts://mqtt-sync.abrova.ir:8885")
    }

    // MARK: - useEmulator (a local server, like Firebase)

    func testUseEmulatorPointsTheApiAndRealtimeAtTheLocalServerWithoutTls() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123").useEmulator(host: "localhost").build()

        XCTAssertEqual(config.apiUrl, "http://localhost:3006")
        XCTAssertEqual(config.mqttServerUri, "mqtt://localhost:1884")
        XCTAssertEqual(config.emulatorHost, "localhost")
    }

    func testUseEmulatorTakesAnotherApiPort() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123").useEmulator(host: "192.168.1.20", port: 4000).build()

        XCTAssertEqual(config.apiUrl, "http://192.168.1.20:4000")
        XCTAssertEqual(config.mqttHost, "192.168.1.20")
    }

    func testWithoutUseEmulatorNothingIsLocal() {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_abc123").build()

        XCTAssertNil(config.emulatorHost)
        XCTAssertEqual(config.apiUrl, "https://sync.abrova.ir")
        XCTAssertTrue(config.mqttUseTls)
    }
}
