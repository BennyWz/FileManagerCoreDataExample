//
//  Keychain+StorageProtocol.swift
//  PersistentDataDemo
//
//  Created by Jorge Benavides on 23/03/23.
//

import Foundation
import Storage

extension Keychain: StorageProtocol {

    // TODO: 2 Make Keychain implement the StorageProtocol
    public func set<T>(_ value: T?, forKey key: StorageKey) throws {
        guard let value = value else {
            return try remove(forKey: key)
        }
        if let data = try toData(value) {
            try update(data, account: key.rawValue)
        } else {
            throw Error.unsupportedType
        }
    }

    public func get<T>(forKey key: StorageKey) throws -> T? {
        guard let data = try read(account: key.rawValue) else {
            return nil
        }
        guard let value = valueFrom(data) as? T else {
            throw Error.unsupportedType
        }
        return value
    }

    public func add<T>(_ value: T?, forKey key: StorageKey) throws {
        guard try get(forKey: key) == nil else {
            throw Error.duplicateEntry
        }
        guard let value = value else {
            return try remove(forKey: key)
        }
        if let data = try toData(value) {
            try save(data, account: key.rawValue)
        } else {
            throw Error.unsupportedType
        }
    }

    public func remove(forKey key: StorageKey) throws {
        try delete(account: key.rawValue)
    }

    public func purge() throws {
        try deleteAll()
    }

}

