import XCTest
@testable import AbrovaSync

/// Tests for AbrovaSyncError enum
final class AbrovaSyncErrorTests: XCTestCase {

    // MARK: - Error Creation

    func testNotInitializedError() {
        let error = AbrovaSyncError.notInitialized

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("not initialized"))
    }

    func testNetworkErrorWithMessage() {
        let error = AbrovaSyncError.networkError("Connection refused", nil)

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Network error"))
        XCTAssertTrue(error.errorDescription!.contains("Connection refused"))
    }

    func testNetworkErrorWithUnderlyingError() {
        let underlying = NSError(domain: "test", code: -1, userInfo: nil)
        let error = AbrovaSyncError.networkError("Connection failed", underlying)

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Connection failed"))
    }

    func testAuthenticationError() {
        let error = AbrovaSyncError.authenticationError("Invalid API key")

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Authentication error"))
        XCTAssertTrue(error.errorDescription!.contains("Invalid API key"))
    }

    func testDatabaseError() {
        let error = AbrovaSyncError.databaseError("Database not found")

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Database error"))
        XCTAssertTrue(error.errorDescription!.contains("Database not found"))
    }

    func testCollectionError() {
        let error = AbrovaSyncError.collectionError("Collection does not exist")

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Collection error"))
        XCTAssertTrue(error.errorDescription!.contains("Collection does not exist"))
    }

    func testDocumentError() {
        let error = AbrovaSyncError.documentError("Document not found")

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Document error"))
        XCTAssertTrue(error.errorDescription!.contains("Document not found"))
    }

    func testConnectionErrorWithMessage() {
        let error = AbrovaSyncError.connectionError("MQTT connection lost", nil)

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Connection error"))
        XCTAssertTrue(error.errorDescription!.contains("MQTT connection lost"))
    }

    func testConnectionErrorWithUnderlyingError() {
        let underlying = NSError(domain: "mqtt", code: 100, userInfo: nil)
        let error = AbrovaSyncError.connectionError("Broker unavailable", underlying)

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Broker unavailable"))
    }

    func testTimeoutError() {
        let error = AbrovaSyncError.timeoutError("Request timed out after 30 seconds")

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Timeout error"))
        XCTAssertTrue(error.errorDescription!.contains("Request timed out"))
    }

    func testPermissionError() {
        let error = AbrovaSyncError.permissionError("Access denied to collection")

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Permission error"))
        XCTAssertTrue(error.errorDescription!.contains("Access denied"))
    }

    func testInvalidResponseError() {
        let error = AbrovaSyncError.invalidResponse("Unexpected JSON format")

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Invalid response"))
        XCTAssertTrue(error.errorDescription!.contains("Unexpected JSON format"))
    }

    func testBatchWriteError() {
        let error = AbrovaSyncError.batchWriteError("Batch exceeded 500 operations limit")

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Batch write error"))
        XCTAssertTrue(error.errorDescription!.contains("500 operations"))
    }

    func testTransactionError() {
        let error = AbrovaSyncError.transactionError("Transaction conflict detected")

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Transaction error"))
        XCTAssertTrue(error.errorDescription!.contains("Transaction conflict"))
    }

    func testUnknownErrorWithUnderlyingError() {
        let underlying = NSError(domain: "unknown", code: 999, userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])
        let error = AbrovaSyncError.unknown(underlying)

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Something went wrong"))
    }

    func testUnknownErrorWithNilError() {
        let error = AbrovaSyncError.unknown(nil)

        XCTAssertNotNil(error.errorDescription)
        XCTAssertTrue(error.errorDescription!.contains("Unknown error"))
    }

    // MARK: - Error Conforms to Error Protocol

    func testErrorConformsToErrorProtocol() {
        let errors: [Error] = [
            AbrovaSyncError.notInitialized,
            AbrovaSyncError.networkError("test", nil),
            AbrovaSyncError.authenticationError("test"),
            AbrovaSyncError.databaseError("test"),
            AbrovaSyncError.collectionError("test"),
            AbrovaSyncError.documentError("test"),
            AbrovaSyncError.connectionError("test", nil),
            AbrovaSyncError.timeoutError("test"),
            AbrovaSyncError.permissionError("test"),
            AbrovaSyncError.invalidResponse("test"),
            AbrovaSyncError.batchWriteError("test"),
            AbrovaSyncError.transactionError("test"),
            AbrovaSyncError.unknown(nil)
        ]

        XCTAssertEqual(errors.count, 13)
        for error in errors {
            XCTAssertNotNil(error.localizedDescription)
        }
    }

    // MARK: - Pattern Matching

    func testPatternMatchingNetworkError() {
        let error: AbrovaSyncError = .networkError("Connection failed", nil)

        switch error {
        case .networkError(let message, _):
            XCTAssertEqual(message, "Connection failed")
        default:
            XCTFail("Expected networkError")
        }
    }

    func testPatternMatchingDocumentError() {
        let error: AbrovaSyncError = .documentError("Not found")

        switch error {
        case .documentError(let message):
            XCTAssertEqual(message, "Not found")
        default:
            XCTFail("Expected documentError")
        }
    }

    // MARK: - Exhaustive Switch

    func testExhaustiveSwitchCoversAllCases() {
        let errors: [AbrovaSyncError] = [
            .notInitialized,
            .networkError("", nil),
            .authenticationError(""),
            .databaseError(""),
            .collectionError(""),
            .documentError(""),
            .connectionError("", nil),
            .timeoutError(""),
            .permissionError(""),
            .invalidResponse(""),
            .batchWriteError(""),
            .transactionError(""),
            .queryNotAllowed("", fields: []),
            .listenerRevoked(""),
            .unknown(nil)
        ]

        for error in errors {
            let description: String
            switch error {
            case .notInitialized:
                description = "notInitialized"
            case .networkError:
                description = "networkError"
            case .authenticationError:
                description = "authenticationError"
            case .databaseError:
                description = "databaseError"
            case .collectionError:
                description = "collectionError"
            case .documentError:
                description = "documentError"
            case .connectionError:
                description = "connectionError"
            case .timeoutError:
                description = "timeoutError"
            case .permissionError:
                description = "permissionError"
            case .invalidResponse:
                description = "invalidResponse"
            case .batchWriteError:
                description = "batchWriteError"
            case .transactionError:
                description = "transactionError"
            case .queryNotAllowed:
                description = "queryNotAllowed"
            case .listenerRevoked:
                description = "listenerRevoked"
            case .unknown:
                description = "unknown"
            }
            XCTAssertFalse(description.isEmpty)
        }
    }
}
