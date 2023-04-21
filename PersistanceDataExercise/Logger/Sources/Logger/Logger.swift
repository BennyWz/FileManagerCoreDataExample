import os.log
import Foundation

public struct Logger: Logging {

    public init() { }

    public func log(_ items: Any..., level: LogLevel = .default, separator: String = " ", terminator: String = "") {
        if #available(iOS 14, *), #available(macOS 11.0, *) {
            Self.osLogger.log(items, level: level, separator: separator, terminator: terminator)
        } else {
            print("\(level.rawValue) \(items.map { String(describing: $0) }.joined(separator: separator) + terminator)")
        }
    }

    @available(iOS 14, *)
    @available(macOS 11.0, *)
    private static let osLogger = os.Logger()

}
