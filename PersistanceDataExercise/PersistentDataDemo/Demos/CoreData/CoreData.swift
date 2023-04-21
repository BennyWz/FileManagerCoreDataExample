//
//  CoreData.swift
//  PersistentDataDemo
//
//  Created by Jorge Benavides on 23/03/23.
//

import Foundation
import CoreData

class CoreData {

    static let `default` = CoreData(modelName: "DataModel")

    private let modelName: String
    private let entityName: String

    init(modelName: String, entityName: String = "Bucket") {
        self.modelName = modelName
        self.entityName = entityName
    }

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var context: NSManagedObjectContext = container.viewContext

    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }

    // MARK: Entity methods
    
    enum Error: Swift.Error {
        case entityNotFound
        case entryNotFound
        case noValueFound
        case unsupportedType
        case duplicateEntry
    }

    private func entity(for name: String, in context: NSManagedObjectContext) throws -> NSEntityDescription {
        guard let entity = NSEntityDescription.entity(forEntityName: name, in: context)
        else { throw Error.entityNotFound }
        return entity
    }

    private func insert(for entity: NSEntityDescription, in context: NSManagedObjectContext) -> NSManagedObject {
        NSManagedObject(entity: entity, insertInto: context)
    }

    private func request(for bucket: String) -> NSFetchRequest<NSFetchRequestResult> {
        NSFetchRequest<NSFetchRequestResult>(entityName: bucket)
    }

    func insert(data: Data, forKey key: String) throws {
        let request = request(for: entityName)
        request.predicate = NSPredicate(format: "key = %@", key)
        request.returnsObjectsAsFaults = false
        if let result = try context.fetch(request).first as? NSManagedObject {
            result.setValue(data, forKey: "value")
        } else {
            let entity = try entity(for: entityName, in: context)
            let object = insert(for: entity, in: context)
            object.setValue(key, forKey: "key")
            object.setValue(data, forKey: "value")
        }
    }

    func read(forKey: String) throws -> Data {
        let request = request(for: entityName)
        request.predicate = NSPredicate(format: "key = %@", forKey)
        request.returnsObjectsAsFaults = false
        guard let result = try context.fetch(request).first as? NSManagedObject else {
            throw Error.entryNotFound
        }
        guard let data = result.value(forKey: "value") as? Data else {
            throw Error.noValueFound
        }
        return data
    }

    func remove(forKey: String) throws {
        let request = request(for: entityName)
        request.predicate = NSPredicate(format: "key = %@", forKey)
        request.returnsObjectsAsFaults = false
        guard let result = try context.fetch(request).first as? NSManagedObject else {
            throw Error.entryNotFound
        }
        context.delete(result)
    }

    func deleteAll() throws {
        let request = request(for: entityName)
        try context.fetch(request).compactMap { $0 as? NSManagedObject }.forEach {
            context.delete($0)
        }
    }
}
