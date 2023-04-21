//
//  CoreData+StorageProtocol.swift
//  PersistentDataDemo
//
//  Created by Jorge Benavides on 23/03/23.
//

import Foundation
import Storage

extension CoreData: StorageProtocol {

    public func set<T>(_ value: T?, forKey key: StorageKey) throws {
        guard let value = value else {
            return try remove(forKey: key)
        }
        if let data = try toData(value) {
            try insert(data: data, forKey: key.rawValue)
        } else {
            throw Error.unsupportedType
        }
    }

    public func get<T>(forKey key: StorageKey) throws -> T? {
        let data = try read(forKey: key.rawValue)
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
            try insert(data: data, forKey: key.rawValue)
        } else {
            throw Error.unsupportedType
        }
    }

    public func remove(forKey key: StorageKey) throws {
        try remove(forKey: key.rawValue)
    }

    public func purge() throws {
        try deleteAll()
    }

}
