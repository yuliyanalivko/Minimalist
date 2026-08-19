import Foundation
import SwiftData

protocol Expirable {
    var cachedAt: Date { get set }
}

protocol Sortable {
    var name: String { get set }
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
    func get<T: Persistable>(type: T.Type, sort: Bool = false) throws -> [T] {
        guard let type = type as? any PersistentModel.Type else {
            return []
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
            return nil
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
        for object in objects {
            guard let model = object as? any PersistentModel & EntityIdentified else {
                continue
            }
            try upsert(model)
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
                return
            }
            
            try deleteExpired(type, olderThan: date)
        } else {
            guard let type = type as? any PersistentModel.Type else {
                return
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
    
    private func fetchAll<T: PersistentModel>(_ type: T.Type, sort: Bool = false) throws -> [T] {
        if sort, let sortableType = T.self as? any (PersistentModel & Sortable).Type {
            return try fetchAllSorted(sortableType) as? [T] ?? []
        }
        
        return try context.fetch(FetchDescriptor<T>())
    }
    
    private func fetchAllSorted<T: PersistentModel & Sortable>(_ type: T.Type) throws -> [T] {
        let descriptor = FetchDescriptor<T>(sortBy: [SortDescriptor(\.name, order: .forward)])
        
        return try context.fetch(descriptor)
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
