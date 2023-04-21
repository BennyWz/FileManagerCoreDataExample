//
//  FileManager.swift
//  PersistentDataDemo
//
//  Created by Jorge Benavides on 23/03/23.
//

import Foundation

extension FileManager {

    enum Error: Swift.Error {
        case pathNotFound
        case unsupportedType
        case duplicateEntry
    }

    private func path(
        for searchPathDirectory: FileManager.SearchPathDirectory = .documentDirectory,
        in domainMask: FileManager.SearchPathDomainMask = .userDomainMask
    ) throws -> URL {
        guard let path = urls(for: searchPathDirectory, in: domainMask).first else {
            throw Error.pathNotFound
        }
        return path
    }

    func save(data: Data, in filename: String) throws {
        let urlPath = try path().appendingPathComponent(filename)
        try data.write(to: urlPath)
    }

    func load(from filename: String) throws -> Data {
        let urlPath = try path().appendingPathComponent(filename)
        return try Data(contentsOf: urlPath)
    }

    func delete(filename: String) throws {
        let urlPath = try path().appendingPathComponent(filename)
        try removeItem(at: urlPath)
    }

    func deleteAll() throws {
        let urlPath = try path()
        guard urlPath.hasDirectoryPath else { return }
        try contentsOfDirectory(at: urlPath, includingPropertiesForKeys: nil).forEach {
            try removeItem(at: $0)
        }
    }
}
