import Foundation
import os.log

/// Log level for AbrovaSync SDK
public enum AbrovaSyncLogLevel: Int {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
    case none = 4
}

/// Internal logger for AbrovaSync SDK
/// All logs are disabled by default to avoid exposing internal implementation details
internal class AbrovaSyncLogger {
    private static let subsystem = "ir.abrova"
    private static let category = "AbrovaSync"
    private static let osLog = OSLog(subsystem: subsystem, category: category)

    static var logLevel: AbrovaSyncLogLevel = .none
    
    static func d(_ message: String) {
        guard logLevel.rawValue <= AbrovaSyncLogLevel.debug.rawValue else { return }
        os_log(.debug, log: osLog, "%{public}@", message)
    }
    
    static func i(_ message: String) {
        guard logLevel.rawValue <= AbrovaSyncLogLevel.info.rawValue else { return }
        os_log(.info, log: osLog, "%{public}@", message)
    }
    
    static func w(_ message: String, error: Error? = nil) {
        guard logLevel.rawValue <= AbrovaSyncLogLevel.warning.rawValue else { return }
        if let error = error {
            os_log(.error, log: osLog, "%{public}@ - %{public}@", message, error.localizedDescription)
        } else {
            os_log(.error, log: osLog, "%{public}@", message)
        }
    }
    
    static func e(_ message: String, error: Error? = nil) {
        guard logLevel.rawValue <= AbrovaSyncLogLevel.error.rawValue else { return }
        if let error = error {
            os_log(.fault, log: osLog, "%{public}@ - %{public}@", message, error.localizedDescription)
        } else {
            os_log(.fault, log: osLog, "%{public}@", message)
        }
    }
}
