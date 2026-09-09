import Foundation

protocol Persistable: AnyObject {}

protocol DatabaseManaging {
    func get<T: Persistable>(type: T.Type, sort: QuerySort?) throws -> [T]
    func get<T: Persistable, KeyType>(type: T.Type, id: KeyType) throws -> T?
    
    func save<T: Persistable>(_ object: T) throws
    func save<T: Persistable>(_ objects: [T]) throws
        
    func delete<T: Persistable>(type: T.Type, olderThan date: Date?) throws
    func delete<T: Persistable, KeyType>(type: T.Type, id: KeyType) throws
    
    func update<T: Persistable, KeyType>(
        type: T.Type,
        id: KeyType,
        _ changes: (T) throws -> Void
    ) throws
}
