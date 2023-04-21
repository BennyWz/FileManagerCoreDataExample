import Foundation

public enum LogLevel: String {
    case `default`, info, debug, error, fault
}

public protocol Logging {
    func log(_ items: Any..., level: LogLevel, separator: String, terminator: String)
}

public extension Logging {
    func log(_ items: Any..., separator: String = " ", terminator: String = "") {
        log(items, level: .default, separator: separator, terminator: terminator)
    }
    func info(_ items: Any..., separator: String = " ", terminator: String = "") {
        log(items, level: .info, separator: separator, terminator: terminator)
    }
    func debug(_ items: Any..., separator: String = " ", terminator: String = "") {
        log(items, level: .debug, separator: separator, terminator: terminator)
    }
    func error(_ items: Any..., separator: String = " ", terminator: String = "") {
        log(items, level: .error, separator: separator, terminator: terminator)
    }
    func fault(_ items: Any..., separator: String = " ", terminator: String = "") {
        log(items, level: .fault, separator: separator, terminator: terminator)
    }
}
