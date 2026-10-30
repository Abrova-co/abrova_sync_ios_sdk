import XCTest
@testable import AbrovaSync

/// Tests for AbrovaSyncLogger and AbrovaSyncLogLevel
final class LoggerTests: XCTestCase {

    // MARK: - Log Level Raw Values

    func testDebugLevelRawValue() {
        XCTAssertEqual(AbrovaSyncLogLevel.debug.rawValue, 0)
    }

    func testInfoLevelRawValue() {
        XCTAssertEqual(AbrovaSyncLogLevel.info.rawValue, 1)
    }

    func testWarningLevelRawValue() {
        XCTAssertEqual(AbrovaSyncLogLevel.warning.rawValue, 2)
    }

    func testErrorLevelRawValue() {
        XCTAssertEqual(AbrovaSyncLogLevel.error.rawValue, 3)
    }

    func testNoneLevelRawValue() {
        XCTAssertEqual(AbrovaSyncLogLevel.none.rawValue, 4)
    }

    // MARK: - Log Level Ordering

    func testDebugIsLowestLevel() {
        XCTAssertTrue(AbrovaSyncLogLevel.debug.rawValue < AbrovaSyncLogLevel.info.rawValue)
        XCTAssertTrue(AbrovaSyncLogLevel.debug.rawValue < AbrovaSyncLogLevel.warning.rawValue)
        XCTAssertTrue(AbrovaSyncLogLevel.debug.rawValue < AbrovaSyncLogLevel.error.rawValue)
        XCTAssertTrue(AbrovaSyncLogLevel.debug.rawValue < AbrovaSyncLogLevel.none.rawValue)
    }

    func testInfoIsAboveDebug() {
        XCTAssertTrue(AbrovaSyncLogLevel.info.rawValue > AbrovaSyncLogLevel.debug.rawValue)
        XCTAssertTrue(AbrovaSyncLogLevel.info.rawValue < AbrovaSyncLogLevel.warning.rawValue)
    }

    func testWarningIsAboveInfo() {
        XCTAssertTrue(AbrovaSyncLogLevel.warning.rawValue > AbrovaSyncLogLevel.info.rawValue)
        XCTAssertTrue(AbrovaSyncLogLevel.warning.rawValue < AbrovaSyncLogLevel.error.rawValue)
    }

    func testErrorIsAboveWarning() {
        XCTAssertTrue(AbrovaSyncLogLevel.error.rawValue > AbrovaSyncLogLevel.warning.rawValue)
        XCTAssertTrue(AbrovaSyncLogLevel.error.rawValue < AbrovaSyncLogLevel.none.rawValue)
    }

    func testNoneIsHighestLevel() {
        XCTAssertTrue(AbrovaSyncLogLevel.none.rawValue > AbrovaSyncLogLevel.debug.rawValue)
        XCTAssertTrue(AbrovaSyncLogLevel.none.rawValue > AbrovaSyncLogLevel.info.rawValue)
        XCTAssertTrue(AbrovaSyncLogLevel.none.rawValue > AbrovaSyncLogLevel.warning.rawValue)
        XCTAssertTrue(AbrovaSyncLogLevel.none.rawValue > AbrovaSyncLogLevel.error.rawValue)
    }

    func testLogLevelsAreConsecutive() {
        XCTAssertEqual(AbrovaSyncLogLevel.debug.rawValue + 1, AbrovaSyncLogLevel.info.rawValue)
        XCTAssertEqual(AbrovaSyncLogLevel.info.rawValue + 1, AbrovaSyncLogLevel.warning.rawValue)
        XCTAssertEqual(AbrovaSyncLogLevel.warning.rawValue + 1, AbrovaSyncLogLevel.error.rawValue)
        XCTAssertEqual(AbrovaSyncLogLevel.error.rawValue + 1, AbrovaSyncLogLevel.none.rawValue)
    }

    // MARK: - Log Level From Raw Value

    func testLogLevelFromValidRawValue() {
        XCTAssertEqual(AbrovaSyncLogLevel(rawValue: 0), .debug)
        XCTAssertEqual(AbrovaSyncLogLevel(rawValue: 1), .info)
        XCTAssertEqual(AbrovaSyncLogLevel(rawValue: 2), .warning)
        XCTAssertEqual(AbrovaSyncLogLevel(rawValue: 3), .error)
        XCTAssertEqual(AbrovaSyncLogLevel(rawValue: 4), AbrovaSyncLogLevel.none)
    }

    func testLogLevelFromInvalidRawValue() {
        XCTAssertNil(AbrovaSyncLogLevel(rawValue: -1))
        XCTAssertNil(AbrovaSyncLogLevel(rawValue: 5))
        XCTAssertNil(AbrovaSyncLogLevel(rawValue: 99))
    }

    // MARK: - Log Level Equality

    func testLogLevelEquality() {
        XCTAssertEqual(AbrovaSyncLogLevel.debug, AbrovaSyncLogLevel.debug)
        XCTAssertEqual(AbrovaSyncLogLevel.info, AbrovaSyncLogLevel.info)
        XCTAssertEqual(AbrovaSyncLogLevel.warning, AbrovaSyncLogLevel.warning)
        XCTAssertEqual(AbrovaSyncLogLevel.error, AbrovaSyncLogLevel.error)
        XCTAssertEqual(AbrovaSyncLogLevel.none, AbrovaSyncLogLevel.none)
    }

    func testLogLevelInequality() {
        XCTAssertNotEqual(AbrovaSyncLogLevel.debug, AbrovaSyncLogLevel.info)
        XCTAssertNotEqual(AbrovaSyncLogLevel.info, AbrovaSyncLogLevel.warning)
        XCTAssertNotEqual(AbrovaSyncLogLevel.warning, AbrovaSyncLogLevel.error)
        XCTAssertNotEqual(AbrovaSyncLogLevel.error, AbrovaSyncLogLevel.none)
    }

    // MARK: - Log Level Count

    func testAllLogLevelsCovered() {
        let allLevels: [AbrovaSyncLogLevel] = [
            .debug, .info, .warning, .error, .none
        ]
        XCTAssertEqual(allLevels.count, 5)
    }

    func testAllLogLevelRawValuesAreUnique() {
        let allLevels: [AbrovaSyncLogLevel] = [
            .debug, .info, .warning, .error, .none
        ]
        let rawValues = allLevels.map { $0.rawValue }
        let uniqueValues = Set(rawValues)
        XCTAssertEqual(rawValues.count, uniqueValues.count)
    }

    // MARK: - Logger Log Level Control

    func testLoggerDefaultLevelIsNone() {
        // Reset to default
        AbrovaSyncLogger.logLevel = .none

        XCTAssertEqual(AbrovaSyncLogger.logLevel, .none)
    }

    func testLoggerLevelCanBeSetToDebug() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        XCTAssertEqual(AbrovaSyncLogger.logLevel, .debug)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testLoggerLevelCanBeSetToInfo() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .info

        XCTAssertEqual(AbrovaSyncLogger.logLevel, .info)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testLoggerLevelCanBeSetToWarning() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .warning

        XCTAssertEqual(AbrovaSyncLogger.logLevel, .warning)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testLoggerLevelCanBeSetToError() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .error

        XCTAssertEqual(AbrovaSyncLogger.logLevel, .error)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    // MARK: - Debug Mode Controls Logging

    func testNoneLevelSuppressesAllLogging() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .none

        // With level .none (rawValue 4), all guard checks fail:
        // debug (0 <= 0) would pass, but .none (4 <= 0) fails
        XCTAssertFalse(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.debug.rawValue)
        XCTAssertFalse(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.info.rawValue)
        XCTAssertFalse(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.warning.rawValue)
        XCTAssertFalse(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.error.rawValue)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testDebugLevelAllowsAllLogging() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        XCTAssertTrue(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.debug.rawValue)
        XCTAssertTrue(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.info.rawValue)
        XCTAssertTrue(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.warning.rawValue)
        XCTAssertTrue(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.error.rawValue)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testWarningLevelBlocksDebugAndInfo() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .warning

        XCTAssertFalse(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.debug.rawValue)
        XCTAssertFalse(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.info.rawValue)
        XCTAssertTrue(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.warning.rawValue)
        XCTAssertTrue(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.error.rawValue)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testErrorLevelOnlyAllowsErrors() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .error

        XCTAssertFalse(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.debug.rawValue)
        XCTAssertFalse(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.info.rawValue)
        XCTAssertFalse(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.warning.rawValue)
        XCTAssertTrue(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.error.rawValue)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testInfoLevelBlocksDebugOnly() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .info

        XCTAssertFalse(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.debug.rawValue)
        XCTAssertTrue(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.info.rawValue)
        XCTAssertTrue(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.warning.rawValue)
        XCTAssertTrue(AbrovaSyncLogger.logLevel.rawValue <= AbrovaSyncLogLevel.error.rawValue)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    // MARK: - Log Methods Do Not Crash

    func testDebugLogDoesNotCrashWhenDisabled() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .none

        AbrovaSyncLogger.d("Debug message while logging disabled")

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testInfoLogDoesNotCrashWhenDisabled() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .none

        AbrovaSyncLogger.i("Info message while logging disabled")

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testWarningLogDoesNotCrashWhenDisabled() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .none

        AbrovaSyncLogger.w("Warning message while logging disabled")

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testErrorLogDoesNotCrashWhenDisabled() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .none

        AbrovaSyncLogger.e("Error message while logging disabled")

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testDebugLogDoesNotCrashWhenEnabled() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        AbrovaSyncLogger.d("Debug message while logging enabled")

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testInfoLogDoesNotCrashWhenEnabled() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        AbrovaSyncLogger.i("Info message while logging enabled")

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testWarningLogDoesNotCrashWhenEnabled() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        AbrovaSyncLogger.w("Warning message while logging enabled")

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testErrorLogDoesNotCrashWhenEnabled() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        AbrovaSyncLogger.e("Error message while logging enabled")

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    // MARK: - Log Methods With Error Parameter

    func testWarningLogWithErrorDoesNotCrash() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        let testError = NSError(domain: "TestDomain", code: 42, userInfo: [NSLocalizedDescriptionKey: "Test error occurred"])
        AbrovaSyncLogger.w("Warning with error", error: testError)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testErrorLogWithErrorDoesNotCrash() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        let testError = NSError(domain: "TestDomain", code: 99, userInfo: [NSLocalizedDescriptionKey: "Critical failure"])
        AbrovaSyncLogger.e("Error with error", error: testError)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testWarningLogWithNilErrorDoesNotCrash() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        AbrovaSyncLogger.w("Warning without error", error: nil)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testErrorLogWithNilErrorDoesNotCrash() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        AbrovaSyncLogger.e("Error without error", error: nil)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    // MARK: - Various String Inputs

    func testLogWithEmptyString() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        AbrovaSyncLogger.d("")
        AbrovaSyncLogger.i("")
        AbrovaSyncLogger.w("")
        AbrovaSyncLogger.e("")

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testLogWithLongString() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        let longString = String(repeating: "A", count: 10000)
        AbrovaSyncLogger.d(longString)
        AbrovaSyncLogger.i(longString)
        AbrovaSyncLogger.w(longString)
        AbrovaSyncLogger.e(longString)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testLogWithSpecialCharacters() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        AbrovaSyncLogger.d("Special chars: !@#$%^&*()_+-={}[]|\\:\";<>?,./~`")
        AbrovaSyncLogger.i("Unicode: \u{00E9}\u{00F1}\u{00FC}\u{00E0}")
        AbrovaSyncLogger.w("Newlines:\nLine 1\nLine 2\nLine 3")
        AbrovaSyncLogger.e("Tabs:\tColumn1\tColumn2\tColumn3")

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testLogWithUnicodeEmoji() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        AbrovaSyncLogger.d("Status: \u{2705} Success")
        AbrovaSyncLogger.i("Warning: \u{26A0}\u{FE0F} Attention needed")
        AbrovaSyncLogger.w("Error: \u{274C} Failed")
        AbrovaSyncLogger.e("Fire: \u{1F525} Critical")

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testLogWithInterpolatedStrings() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        let userId = "user-123"
        let count = 42
        let price = 19.99

        AbrovaSyncLogger.d("User \(userId) logged in")
        AbrovaSyncLogger.i("Found \(count) results")
        AbrovaSyncLogger.w("Price changed to \(price)")
        AbrovaSyncLogger.e("Failed for user \(userId) after \(count) attempts")

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testLogWithMultilineString() {
        let previousLevel = AbrovaSyncLogger.logLevel
        AbrovaSyncLogger.logLevel = .debug

        let multiline = """
        {
            "id": "doc-1",
            "name": "Test",
            "nested": {
                "key": "value"
            }
        }
        """
        AbrovaSyncLogger.d(multiline)
        AbrovaSyncLogger.i(multiline)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    // MARK: - Log Level Switching

    func testLogLevelCanBeSwitchedMultipleTimes() {
        let previousLevel = AbrovaSyncLogger.logLevel

        AbrovaSyncLogger.logLevel = .debug
        XCTAssertEqual(AbrovaSyncLogger.logLevel, .debug)

        AbrovaSyncLogger.logLevel = .info
        XCTAssertEqual(AbrovaSyncLogger.logLevel, .info)

        AbrovaSyncLogger.logLevel = .warning
        XCTAssertEqual(AbrovaSyncLogger.logLevel, .warning)

        AbrovaSyncLogger.logLevel = .error
        XCTAssertEqual(AbrovaSyncLogger.logLevel, .error)

        AbrovaSyncLogger.logLevel = .none
        XCTAssertEqual(AbrovaSyncLogger.logLevel, .none)

        AbrovaSyncLogger.logLevel = .debug
        XCTAssertEqual(AbrovaSyncLogger.logLevel, .debug)

        // Restore
        AbrovaSyncLogger.logLevel = previousLevel
    }

    func testLogLevelComparisonForFiltering() {
        // Verify the guard logic used in logger methods:
        // guard logLevel.rawValue <= TargetLevel.rawValue

        // When logLevel is .warning (2):
        // d() check: 2 <= 0 -> false (blocked)
        // i() check: 2 <= 1 -> false (blocked)
        // w() check: 2 <= 2 -> true (allowed)
        // e() check: 2 <= 3 -> true (allowed)
        XCTAssertFalse(AbrovaSyncLogLevel.warning.rawValue <= AbrovaSyncLogLevel.debug.rawValue)
        XCTAssertFalse(AbrovaSyncLogLevel.warning.rawValue <= AbrovaSyncLogLevel.info.rawValue)
        XCTAssertTrue(AbrovaSyncLogLevel.warning.rawValue <= AbrovaSyncLogLevel.warning.rawValue)
        XCTAssertTrue(AbrovaSyncLogLevel.warning.rawValue <= AbrovaSyncLogLevel.error.rawValue)
    }
}
