import OSLog

@available(iOS 14, *)
@available(macOS 11.0, *)
extension os.Logger: Logging {
    public func log(_ items: Any..., level: LogLevel, separator: String, terminator: String) {
        log(level: level.osLevel, "\(items.map { String(describing: $0) }.joined(separator: separator) + terminator)")
    }
}

@available(iOS 14, *)
@available(macOS 11.0, *)
extension LogLevel {
    var osLevel: OSLogType {
        switch self {
        case .default:
            return .default
        case .info:
            return .info
        case .debug:
            return .debug
        case .error:
            return .error
        case .fault:
            return .fault
        }
    }

}
