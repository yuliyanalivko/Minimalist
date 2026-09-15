import RealmSwift
import Foundation

extension Object: Persistable {}

class RealmDatabaseManager: DatabaseManaging {
    private let configuration: Realm.Configuration
    
    init(configuration: Realm.Configuration = RealmConfigurationFactory.make()) {
        self.configuration = configuration
    }
    
    /// Fetches all persisted objects of a specified type from the database as an array.
    /// - Parameter type: The Object model type to query from the database.
    /// - Parameter sort: A Boolean flag indicating whether to sort the fetched records alphabetically by name. Defaults to `false`.
    /// - Returns: An array containing all stored instances of the specified type.
    func get<T: Persistable>(type: T.Type, sort: StorageSortOption? = nil) throws -> [T] {
        guard let type = type as? Object.Type else {
            throw MinimalistError.persistenceTypeError
        }
        
        let realm = try realm()
        var results = realm.objects(type)
                
        if let sort {
            results = results.sorted(byKeyPath: sort.keyPath)
        }
        
        return Array(results) as? [T] ?? []
    }
    
    /// Fetches a single object from the database using its primary key.
    /// - Parameters:
    ///   - type: The Realm object type to fetch.
    ///   - id: The primary key value used to locate the object.
    /// - Returns: The matching Realm object, or `nil` if no record was found for the given ID.
    func get<T: Persistable, KeyType>(type: T.Type, id: KeyType) throws -> T? {
        guard let type = type as? Object.Type else {
            throw MinimalistError.persistenceTypeError
        }
        
        let realm = try realm()
        
        guard let object = realm.object(ofType: type, forPrimaryKey: id) else {
            return nil
        }
        
        return object as? T
    }
    
    /// Saves or updates a single object in the database.
    /// - Parameter object: The Realm object to persist or update
    func save<T: Persistable>(_ object: T) throws {
        guard let object = object as? Object else {
            throw MinimalistError.persistenceTypeError
        }
        
        let realm = try realm()
        
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    /// Saves or updates a collection of objects in the database.
    /// - Parameter objects: The array of Realm objects to persist or update
    func save<T: Persistable>(_ objects: [T]) throws {
        let objects = try objects.map { object in
            guard let object = object as? Object else {
                throw MinimalistError.persistenceTypeError
            }
            
            return object
        }
        
        let realm = try realm()
        
        try realm.write {
            realm.add(objects, update: .modified)
        }
    }
    
    /// Removes all persisted objects of a specified type from the database.
    /// - Parameter type: The Realm object type to delete.
    /// - Parameter date: An optional cutoff date. If provided, only items cached before this date are deleted; if nil, all items of the given type are deleted.
    func delete<T: Persistable>(type: T.Type, olderThan date: Date? = nil) throws {
        guard let type = type as? Object.Type else {
            throw MinimalistError.persistenceTypeError
        }
        
        let realm = try realm()
        
        try realm.write {
            var objects = realm.objects(type)
            
            if let date {
                objects = objects.filter("cachedAt < %@", date)
            }
            
            realm.delete(objects)
        }
    }
    
    /// Removes an object from the database using its primary key.
    /// - Parameters:
    ///   - type: The Realm object type to delete.
    ///   - id: The primary key of the object to remove.
    func delete<T: Persistable, KeyType>(type: T.Type, id: KeyType) throws {
        guard let type = type as? Object.Type else {
            throw MinimalistError.persistenceTypeError
        }
        
        let realm = try realm()
        
        try realm.write {
            if let object = realm.object(ofType: type, forPrimaryKey: id) {
                realm.delete(object)
            }
        }
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
        guard let object = try get(type: type, id: id) else {
            return
        }
        
        let realm = try realm()

        try realm.write {
            try changes(object)
            
            if let expirable = object as? Expirable {
                expirable.cachedAt = Date()
            }
        }
    }
    
    private func realm() throws -> Realm {
        try Realm(configuration: configuration)
    }
}
