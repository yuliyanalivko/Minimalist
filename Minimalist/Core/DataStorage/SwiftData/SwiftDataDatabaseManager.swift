import Foundation
import SwiftData

protocol Expirable: AnyObject {
    var cachedAt: Date { get set }
}

@MainActor
final class SwiftDataDatabaseManager: DatabaseManaging {
    private let container: ModelContainer

    private var context: ModelContext { container.mainContext }
    
    init(container: ModelContainer) {
        self.container = container
    }
    
    /// Fetches all persisted records of a specified type from the database.
    /// - Parameter type: The persistent model type to query from the database.
    /// - Parameter sort: A Boolean flag indicating whether to sort the fetched records alphabetically by name. Defaults to `false`.
    /// - Returns: An array containing all stored instances matching the specified type.
    func get<T: Persistable>(type: T.Type, sort: StorageSortOption? = nil) throws -> [T] {
        guard let type = type as? any PersistentModel.Type else {
            throw MinimalistError.persistenceTypeError
        }
        
        return try fetchAll(type, sort: sort) as? [T] ?? []
    }
    
    /// Fetches a single persisted record matching a specific unique identifier.
    /// - Parameters:
    ///   - type: The persistent model type to query from the database.
    ///   - id: The unique key identifier used to match the target entity.
    /// - Returns: The matching instance if found; otherwise, `nil`.
    func get<T: Persistable, KeyType>(type: T.Type, id: KeyType) throws -> T? {
        guard let id = id as? String,
              let type = type as? any (PersistentModel & EntityIdentified).Type else {
            throw MinimalistError.persistenceTypeError
        }
        
        return try fetchByEntityId(type, id: id) as? T
    }
    
    /// Saves or updates a single object in the database.
    /// - Parameter object: The record instance to be persisted or updated.
    func save<T: Persistable>(_ object: T) throws {
        try save([object])
    }
    
    /// Saves or updates a collection of objects in the database.
    /// - Parameter objects: An array of record instances to be persisted or updated.
    func save<T: Persistable>(_ objects: [T]) throws {
        let objects: [any PersistentModel & EntityIdentified] = try objects.map { object in
            guard let object = object as? any PersistentModel & EntityIdentified else {
                throw MinimalistError.persistenceTypeError
            }
            
            return object
        }
        
        for object in objects {
            try upsert(object)
        }
        
        try context.save()
    }
    
    
    /// Deletes records of a specified type, with an optional filter for expiration date.
    /// - Parameters:
    ///   - type: The persistent model type to target for deletion.
    ///   - date: An optional cutoff date. If provided, only items cached before this date are deleted; if nil, all items of the given type are deleted.
    func delete<T: Persistable>(type: T.Type, olderThan date: Date? = nil) throws {
        if let date {
            guard let type = type as? any (PersistentModel & Expirable).Type else {
                throw MinimalistError.persistenceTypeError
            }
            
            try deleteExpired(type, olderThan: date)
        } else {
            guard let type = type as? any PersistentModel.Type else {
                throw MinimalistError.persistenceTypeError
            }
            
            try deleteAll(type)
        }
        try context.save()
    }
    
    /// Deletes a specific record matching the provided unique identifier.
    /// - Parameters:
    ///   - type: The persistent model type to target for deletion.
    ///   - id: The unique key identifier of the object to remove.
    func delete<T: Persistable, KeyType>(type: T.Type, id: KeyType) throws {
        guard let object = try get(type: type, id: id) as? any PersistentModel else {
            return
        }
        
        context.delete(object)
        try context.save()
    }
    
    /// Updates an existing database record by fetching it and executing a closure containing the modifications.
    /// - Parameters:
    ///   - type: The persistent model class or struct type to find.
    ///   - id: The unique identifier of the record to be updated.
    ///   - changes: A throwing closure that accepts the retrieved object and modifies its properties.
    func update<T: Persistable, KeyType>(
        type: T.Type,
        id: KeyType,
        _ changes: (T) throws -> Void
    ) throws {
        guard var object = try get(type: type, id: id) else {
            return
        }
        
        try changes(object)
        
        if let expirable = object as? Expirable {
            expirable.cachedAt = Date()
        }
        
        try context.save()
    }
    
    private func upsert(_ model: some PersistentModel & EntityIdentified) throws {
        try deleteExisting(type(of: model), entityId: model.entityId)
        context.insert(model)
    }
    
    private func deleteExisting<T: PersistentModel & EntityIdentified>(
        _ type: T.Type,
        entityId: String
    ) throws {
        if let existing = try fetchByEntityId(type, id: entityId) {
            context.delete(existing)
        }
    }
    
    private func fetchByEntityId<T: PersistentModel & EntityIdentified>(
        _ type: T.Type,
        id: String
    ) throws -> T? {
        try fetchAll(type).first { $0.entityId == id }
    }
    
    private func fetchAll<T: PersistentModel>(_ type: T.Type, sort: StorageSortOption? = nil) throws -> [T] {
        if let sort, let sortableType = T.self as? any (PersistentModel & Sortable).Type {
            return try fetchAllSorted(sortableType, sort: sort) as? [T] ?? []
        }
        
        return try context.fetch(FetchDescriptor<T>())
    }
    
    private func fetchAllSorted<T: PersistentModel & Sortable>(
        _ type: T.Type,
        sort: StorageSortOption
    ) throws -> [T.SortableModel] {
        let descriptors = T.sortDescriptors(for: sort)
        
        return try context.fetch(FetchDescriptor<T.SortableModel>(sortBy: descriptors))
    }
    
    private func deleteAll<T: PersistentModel>(_ type: T.Type) throws {
        try context.delete(model: type)
    }
    
    private func deleteExpired<T: PersistentModel & Expirable>(
        _ type: T.Type,
        olderThan date: Date
    ) throws {
        let expired = try fetchAll(type).filter { $0.cachedAt < date }
        
        for object in expired {
            context.delete(object)
        }
    }
}
