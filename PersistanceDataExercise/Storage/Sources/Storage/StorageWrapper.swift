import Foundation

@propertyWrapper
public struct Storageble<Value: Codable> {
    public var wrappedValue: Value?
    public init() {}
}
