import XCTest
@testable import AbrovaSync

/// X-Abrova-SDK: `ios/<version>`, or the wrapper first with the native SDK underneath.
final class SdkHeaderTests: XCTestCase {

    func testSdkVersionMatchesPodspec() throws {
        let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
        let spec = try String(contentsOf: root.appendingPathComponent("AbrovaSync.podspec"), encoding: .utf8)
        XCTAssertTrue(
            spec.contains("s.version          = '\(AbrovaSync.version)'"),
            "AbrovaSync.podspec version does not match AbrovaSync.version (\(AbrovaSync.version))"
        )
    }

    func testEveryRequestCarriesNativeIdentity() async throws {
        let api = ApiClient(config: AbrovaSyncConfig(apiKey: "ab_live_test"))
        for endpoint in ["/databases", "/connections/token"] {
            let request = try await api.buildRequest(endpoint: endpoint, method: "POST")
            XCTAssertEqual(request.value(forHTTPHeaderField: "X-Abrova-SDK"), "ios/\(AbrovaSync.version)")
            XCTAssertEqual(request.value(forHTTPHeaderField: "X-API-Key"), "ab_live_test")
        }
    }

    func testWrapperIsReportedFirst() async throws {
        let config = AbrovaSyncConfigBuilder(apiKey: "ab_live_test").wrapperSdk(name: "flutter", version: "0.2.4").build()
        let request = try await ApiClient(config: config).buildRequest(endpoint: "/databases")
        XCTAssertEqual(request.value(forHTTPHeaderField: "X-Abrova-SDK"), "flutter/0.2.4 ios/\(AbrovaSync.version)")
    }

    func testInvalidOrHalfSetWrapperFallsBackToNative() {
        let native = "ios/\(AbrovaSync.version)"
        XCTAssertEqual(AbrovaSyncConfig(apiKey: "k").sdkHeaderValue, native)
        XCTAssertEqual(AbrovaSyncConfig(apiKey: "k", wrapperSdkName: "flutter").sdkHeaderValue, native)
        XCTAssertEqual(AbrovaSyncConfig(apiKey: "k", wrapperSdkName: "flut ter", wrapperSdkVersion: "1.0").sdkHeaderValue, native)
        XCTAssertEqual(AbrovaSyncConfig(apiKey: "k", wrapperSdkName: String(repeating: "x", count: 33), wrapperSdkVersion: "1.0").sdkHeaderValue, native)
        XCTAssertEqual(
            AbrovaSyncConfig(apiKey: "k", wrapperSdkName: "react-native", wrapperSdkVersion: "1.0.0+2").sdkHeaderValue,
            "react-native/1.0.0+2 \(native)"
        )
    }
}
