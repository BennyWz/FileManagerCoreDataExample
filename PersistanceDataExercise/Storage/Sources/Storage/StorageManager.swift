import Foundation
import Logger

public struct StorageManager {

    private let storage: StorageProtocol
    private let logger: Logging

    public init(storage: StorageProtocol, logger: Logging = Logger()) {
        self.storage = storage
        self.logger = logger
    }

}

// TODO: 1 Make StorageManager implement the StorageManagerProtocol
extension StorageManager: StorageManagerProtocol {

    public func set<T>(_ value: T?, forKey key: StorageKey) {
        do {
            try storage.set(value, forKey: key)
        } catch {
            logger.error(error)
        }
    }

    public func get<T>(forKey key: StorageKey) -> T? {
        do {
            return try storage.get(forKey: key)
        } catch {
            logger.error(error)
        }
        return nil
    }

    public func add<T>(_ value: T?, forKey key: StorageKey) {
        do {
            try storage.add(value, forKey: key)
        } catch {
            logger.error(error)
        }
    }

    public func remove(forKey key: StorageKey) {
        do {
            return try storage.remove(forKey: key)
        } catch {
            logger.error(error)
        }
    }

    public func store<T: Encodable>(_ value: T?, forKey key: StorageKey, usingEncoder encoder: JSONEncoder) {
        do {
            try storage.store(value, forKey: key, usingEncoder: encoder)
        } catch {
            logger.error(error)
        }
    }

    public func retrieve<T: Decodable>(forKey key: StorageKey, usingDecoder decoder: JSONDecoder) -> T? {
        do {
            return try storage.retrieve(forKey: key, usingDecoder: decoder)
        } catch {
            logger.error(error)
        }
        return nil
    }

    public func purge() {
        do {
            return try storage.purge()
        } catch {
            logger.error(error)
        }
    }

}
