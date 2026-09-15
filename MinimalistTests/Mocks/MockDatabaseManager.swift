import Foundation
import RealmSwift
@testable import Minimalist

final class MockDatabaseManager: DatabaseManaging, @unchecked Sendable {
    var objects: [Object] = []
    var getError: Error?
    var saveError: Error?
    
    func get<T: Persistable>(type: T.Type, sort: StorageSortOption? = nil) throws -> [T] {
        if let getError {
            throw getError
        }
        
        var result = objects.compactMap { $0 as? T }
        
        if let sort {
            result.sort { lhs, rhs in
                switch sort {
                case .name:
                    objectName(lhs) < objectName(rhs)
                }
            }
        }
        
        return result
    }
    
    func get<T: Persistable, KeyType>(type: T.Type, id: KeyType) throws -> T? {
        if let getError {
            throw getError
        }
        
        return objects.compactMap { $0 as? T }.first { object in
            guard let objectId = (object as? Object)?.value(forKey: "id") as? AnyHashable,
                  let id = id as? AnyHashable else {
                return false
            }
            
            return objectId == id
        }
    }
    
    func save<T: Persistable>(_ object: T) throws {
        if let saveError {
            throw saveError
        }
        
        guard let object = object as? Object else { return }
        let id = object.value(forKey: "id") as? String
        
        objects.removeAll {
            $0 is T && ($0.value(forKey: "id") as? String) == id
        }
        objects.append(object)
    }
    
    func save<T: Persistable>(_ objects: [T]) throws {
        for object in objects {
            try save(object)
        }
    }
        
    func delete<T: Persistable>(type: T.Type, olderThan date: Date?) throws {
        objects.removeAll { object in
            guard object is T else { return false }
            
            guard let date else { return true }
            
            guard let cachedAt = object.value(forKey: "cachedAt") as? Date else {
                return false
            }
            
            return cachedAt < date
        }
    }
    
    func delete<T: Persistable, KeyType>(type: T.Type, id: KeyType) throws {
        objects.removeAll { object in
            guard object is T,
                  let objectId = object.value(forKey: "id") as? AnyHashable,
                  let targetId = id as? AnyHashable else {
                return false
            }
            
            return objectId == targetId
        }
    }
    
    func update<T: Persistable, KeyType>(
        type: T.Type,
        id: KeyType,
        _ changes: (T) throws -> Void
    ) throws {
        guard let object = try get(type: type, id: id) else {
            return
        }
        
        try changes(object)
    }
    
    private func objectName<T>(_ object: T) -> String {
        (object as? Object)?.value(forKey: "name") as? String ?? ""
    }
    
    private func objectCachedAt<T>(_ object: T) -> Date {
        (object as? Object)?.value(forKey: "cachedAt") as? Date ?? .distantPast
    }
}
