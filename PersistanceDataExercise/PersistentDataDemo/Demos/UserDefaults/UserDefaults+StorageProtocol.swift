//
//  UserDefaults+StorageProtocol.swift
//  PersistentDataDemo
//
//  Created by Jorge Benavides on 23/03/23.
//

import Foundation
import Storage

extension UserDefaults: StorageProtocol {
    // TODO: 1 Make User defaults implement the StorageProtocol

    enum Error: Swift.Error {
        case duplicateEntry
    }

    public func set<T>(_ value: T?, forKey key: StorageKey) throws {
        set(value, forKey: key.rawValue)
    }

    public func get<T>(forKey key: StorageKey) throws -> T? {
        object(forKey: key.rawValue) as? T
    }

    public func add<T>(_ value: T?, forKey key: Storage.StorageKey) throws {
        guard try get(forKey: key) == nil else {
            throw Error.duplicateEntry
        }
        try set(value, forKey: key)
    }

    public func remove(forKey key: StorageKey) throws {
        removeObject(forKey: key.rawValue)
    }

    public func purge() throws {
        removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }
}
