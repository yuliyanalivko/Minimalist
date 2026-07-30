import Foundation
import RealmSwift
@testable import Minimalist

final class MockDatabaseManager: DatabaseManaging, @unchecked Sendable {
    var objects: [Object] = []
    var getError: Error?
    var saveError: Error?
    
    func get<T: Object>(type: T.Type) throws -> [T] {
        if let getError {
            throw getError
        }
        
        return objects.compactMap { $0 as? T }
    }
    
    func get<T: Object, KeyType>(type: T.Type, id: KeyType) throws -> T? {
        if let getError {
            throw getError
        }
        
        return objects.compactMap { $0 as? T }.first { object in
            guard let objectId = object.value(forKey: "id") as? AnyHashable,
                  let id = id as? AnyHashable else {
                return false
            }
            
            return objectId == id
        }
    }
    
    func save<T: Object>(_ object: T) throws {
        if let saveError {
            throw saveError
        }
        
        objects.removeAll { ($0 as? T)?.value(forKey: "id") as? String == object.value(forKey: "id") as? String }
        objects.append(object)
    }
    
    func save<T: Object>(_ objects: [T]) throws {
        for object in objects {
            try save(object)
        }
    }
    
    func delete<T: Object>(type: T.Type, olderThan date: Date?) throws {
        objects.removeAll { object in
            guard let typed = object as? T else { return false }
            
            guard let date else { return true }
            
            guard let cachedAt = typed.value(forKey: "cachedAt") as? Date else {
                return false
            }
            
            return cachedAt < date
        }
    }
    
    func delete<T: Object, KeyType>(type: T.Type, id: KeyType) throws {
        objects.removeAll { object in
            guard let typedObject = object as? T,
                  let objectId = typedObject.value(forKey: "id") as? AnyHashable,
                  let targetId = id as? AnyHashable else {
                return false
            }
            
            return objectId == targetId
        }
    }
}
