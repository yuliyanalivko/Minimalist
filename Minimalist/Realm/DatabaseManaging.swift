import RealmSwift
import Foundation

protocol DatabaseManaging {
    func get<T: Object>(type: T.Type) throws -> [T]
    func get<T: Object, KeyType>(type: T.Type, id: KeyType) throws -> T?
    
    func save<T: Object>(_ object: T) throws
    func save<T: Object>(_ objects: [T]) throws
    
    func delete<T: Object>(type: T.Type, olderThan date: Date?) throws
    func delete<T: Object, KeyType>(type: T.Type, id: KeyType) throws
}
