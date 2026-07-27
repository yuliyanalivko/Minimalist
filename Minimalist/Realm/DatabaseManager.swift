import RealmSwift
import Foundation

class DatabaseManager: DatabaseManaging {
    private let configuration: Realm.Configuration
    
    init(configuration: Realm.Configuration = .defaultConfiguration) {
        self.configuration = configuration
    }
    
    /// Fetches all persisted objects of a specified type from the database as an array.
    /// - Parameter type: The Object model type to query from the database.
    /// - Returns: An array containing all stored instances of the specified type.
    func get<T: Object>(type: T.Type) throws -> [T] {
        let realm = try realm()
        let results = realm.objects(type)
        
        return Array(results)
    }
    
    /// Fetches a single object from the database using its primary key.
    /// - Parameters:
    ///   - type: The Realm object type to fetch.
    ///   - id: The primary key value used to locate the object.
    /// - Returns: The matching Realm object, or `nil` if no record was found for the given ID.
    func get<T: Object, KeyType>(type: T.Type, id: KeyType) throws -> T? {
        let realm = try realm()

        guard let object = realm.object(ofType: type, forPrimaryKey: id) else {
            return nil
        }
        
        return object
    }
    
    /// Saves or updates a single object in the database.
    /// - Parameter object: The Realm object to persist or update
    func save<T: Object>(_ object: T) throws {
        let realm = try realm()
        
        try realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    /// Saves or updates a collection of objects in the database.
    /// - Parameter objects: The array of Realm objects to persist or update
    func save<T: Object>(_ objects: [T]) throws {
        let realm = try realm()
        
        try realm.write {
            realm.add(objects, update: .modified)
        }
    }
    
    /// Removes all persisted objects of a specified type from the database.
    ///
    /// - Parameter type: The Realm object type to delete.
    func delete<T: Object>(type: T.Type) throws {
        let realm = try realm()
        
        try realm.write {
            let objects = realm.objects(type)
            realm.delete(objects)
        }
    }
    
    /// Removes an object from the database using its primary key.
    /// - Parameters:
    ///   - type: The Realm object type to delete.
    ///   - id: The primary key of the object to remove.
    func delete<T: Object, KeyType>(type: T.Type, id: KeyType) throws {
        let realm = try realm()
        
        try realm.write {
            if let object = realm.object(ofType: type, forPrimaryKey: id) {
                realm.delete(object)
            }
        }
    }
    
    private func realm() throws -> Realm {
        try Realm(configuration: configuration)
    }
}

