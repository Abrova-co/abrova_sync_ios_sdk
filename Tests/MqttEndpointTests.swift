import XCTest
@testable import AbrovaSync

final class MqttEndpointTests: XCTestCase {
    private let fallback = MqttEndpoint(host: "mqtt-sync.abrova.ir", port: 8885, useTls: true)

    func testUsesTheServersEndpointWhenValid() {
        XCTAssertEqual(MqttEndpoint.resolve(host: "mqtt-sync.abrova.ir", port: 8885, useTls: true, default: fallback), MqttEndpoint(host: "mqtt-sync.abrova.ir", port: 8885, useTls: true))
        XCTAssertEqual(MqttEndpoint.resolve(host: "Abrova.ir ", port: 443, useTls: true, default: fallback), MqttEndpoint(host: "abrova.ir", port: 443, useTls: true))
    }

    func testFallsBackWhenMissingOrIncomplete() {
        XCTAssertEqual(MqttEndpoint.resolve(host: nil, port: nil, useTls: nil, default: fallback), fallback)
        XCTAssertEqual(MqttEndpoint.resolve(host: "mqtt-sync.abrova.ir", port: nil, useTls: true, default: fallback), fallback)
        XCTAssertEqual(MqttEndpoint.resolve(host: "mqtt-sync.abrova.ir", port: 8885, useTls: nil, default: fallback), fallback)
    }

    func testNeverAnotherDomainOrInvalidPort() {
        for host in ["evil.com", "abrova.ir.evil.com", "evilabrova.ir", "mqtt-sync.abrova.com", "10.0.0.1", "mqtt sync.abrova.ir", "-x.abrova.ir"] {
            XCTAssertEqual(MqttEndpoint.resolve(host: host, port: 8885, useTls: true, default: fallback), fallback, host)
        }
        for port in [0, -1, 65536] {
            XCTAssertEqual(MqttEndpoint.resolve(host: "mqtt-sync.abrova.ir", port: port, useTls: true, default: fallback), fallback)
        }
    }

    func testNeverUnencryptedWhateverTheServerAnswers() {
        XCTAssertEqual(MqttEndpoint.resolve(host: "mqtt-sync.abrova.ir", port: 1884, useTls: false, default: fallback), fallback)
        XCTAssertEqual(MqttEndpoint.resolve(host: "other.abrova.ir", port: 1884, useTls: false, default: fallback), fallback)
    }

    func testTheBuiltInEndpointsAreEncrypted() {
        let config = AbrovaSyncConfig(apiKey: "ab_live_x")
        XCTAssertEqual(MqttEndpoint(host: config.mqttHost, port: config.mqttPort, useTls: config.mqttUseTls), fallback)
        XCTAssertEqual(config.mqttServerUri, "mqtts://mqtt-sync.abrova.ir:8885")
        XCTAssertEqual(config.apiUrl, "https://sync.abrova.ir")
    }
}
