//
//  Keychain.swift
//  PersistentDataDemo
//
//  Created by Jorge Benavides on 23/03/23.
//

import Foundation

protocol KeychainProtocol {
    func save(_ data: Data, account: String) throws
    func update(_ data: Data, account: String) throws
    func read(account: String) throws -> Data?
    func delete(account: String) throws
}

public struct Keychain {

    static let standard = Keychain(service: "standard")

    private let service: String
    private let accessGroup: String?

    public init(service: String, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
    }

    enum Error: Swift.Error {
        case duplicateEntry
        case unsupportedType
        case unkwown(OSStatus)

        static func from(_ status: OSStatus) -> Self? {
            switch status {
            case errSecSuccess:
                return nil
            case errSecDuplicateItem:
                return .duplicateEntry
            default:
                return .unkwown(status)
            }
        }
    }

    func query(service: String, account: String) -> [String: Any] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        return query
    }
    
}

extension Keychain: KeychainProtocol {

    func save(_ data: Data, account: String) throws {
        var query = query(service: service, account: account)
        query[kSecValueData as String] = data as AnyObject?

        let status = SecItemAdd(query as CFDictionary, nil)

        guard let error = Error.from(status) else { return }
        throw error
    }

    func update(_ data: Data, account: String) throws {
        do {
            try save(data, account: account)
        } catch Error.duplicateEntry {
            let query = query(service: service, account: account)
            let status = SecItemUpdate(query as CFDictionary, [kSecValueData as String: data] as CFDictionary)

            guard let error = Error.from(status) else { return }
            throw error
        } catch {
            throw error
        }
    }

    func read(account: String) throws -> Data? {
        var query = query(service: service, account: account)
        query[kSecReturnData as String] =  kCFBooleanTrue
        query[kSecMatchLimit as String] =  kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard let error = Error.from(status) else {
            return result as? Data
        }
        throw error
    }

    func delete(account: String) throws {
        let query = query(service: service, account: account)
        let status = SecItemDelete(query as CFDictionary)
        guard let error = Error.from(status) else { return }
        throw error
    }

    func deleteAll() throws {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        let status = SecItemDelete(query as CFDictionary)
        guard let error = Error.from(status) else { return }
        throw error
    }
}
