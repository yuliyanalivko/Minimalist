import Testing
import Foundation
import RealmSwift
@testable import Minimalist

@MainActor
struct RealmDatabaseManagerTests {

    private func makeManager() throws -> RealmDatabaseManager {
        let config = Realm.Configuration(
            inMemoryIdentifier: UUID().uuidString,
            objectTypes: [RealmCategory.self, RealmSubCategory.self]
        )

        return RealmDatabaseManager(configuration: config)
    }

    @Test("Should save and get data")
    func save_thenGet_returnSavedObjects() throws {
        let manager = try makeManager()
        let entity = Category(
            id: "1",
            name: "Sofas",
            thumbnailUrl: nil,
            subCategories: []
        ).toRealm()

        try manager.save(entity)
        let result = try manager.get(type: RealmCategory.self)

        #expect(result.count == 1)
        #expect(result.first?.id == "1")
        #expect(result.first?.name == "Sofas")
    }

    @Test("Should update existing object by primary key")
    func save_withSameId_updateObject() throws {
        let manager = try makeManager()
        try manager.save(Category(id: "1", name: "Sofas", thumbnailUrl: nil, subCategories: []).toRealm())
        try manager.save(Category(id: "1", name: "Updated", thumbnailUrl: nil, subCategories: []).toRealm())

        let result = try manager.get(type: RealmCategory.self)

        #expect(result.count == 1)
        #expect(result.first?.name == "Updated")
    }

    @Test("Should get data by id")
    func get_byId_returnObject() throws {
        let manager = try makeManager()
        try manager.save(Category(id: "2", name: "Tables", thumbnailUrl: nil, subCategories: []).toRealm())
        
        let result = try manager.get(type: RealmCategory.self, id: "2")

        #expect(result?.name == "Tables")
    }

    @Test("Should delete by id")
    func delete_byId_removeObject() throws {
        let manager = try makeManager()
        try manager.save(Category(id: "1", name: "Sofas", thumbnailUrl: nil, subCategories: []).toRealm())

        try manager.delete(type: RealmCategory.self, id: "1")
        let result = try manager.get(type: RealmCategory.self)

        #expect(result.isEmpty)
    }

    @Test("Should delete all of type")
    func delete_type_removeAll() throws {
        let manager = try makeManager()
        try manager.save([
            Category(id: "1", name: "Sofas", thumbnailUrl: nil, subCategories: []).toRealm(),
            Category(id: "2", name: "Tables", thumbnailUrl: nil, subCategories: []).toRealm()
        ])

        try manager.delete(type: RealmCategory.self)

        #expect(try manager.get(type: RealmCategory.self).isEmpty)
    }
    
    @Test("Should throw persistenceTypeError for unsupported types")
    func operations_throwPersistenceTypeError_forUnsupportedType() throws {
        final class UnsupportedPersistable: Persistable {}
        
        let manager = try makeManager()
        let isPersistenceTypeError: (Error) -> Bool = { error in
            if case .persistenceTypeError = error as? MinimalistError {
                return true
            }
            
            return false
        }
        
        #expect {
            try manager.get(type: UnsupportedPersistable.self)
        } throws: { isPersistenceTypeError($0) }
        #expect {
            try manager.get(type: UnsupportedPersistable.self, id: "1")
        } throws: { isPersistenceTypeError($0) }
        #expect {
            try manager.save(UnsupportedPersistable())
        } throws: { isPersistenceTypeError($0) }
        #expect {
            try manager.delete(type: UnsupportedPersistable.self)
        } throws: { isPersistenceTypeError($0) }
        #expect {
            try manager.delete(type: UnsupportedPersistable.self, id: "1")
        } throws: { isPersistenceTypeError($0) }
    }
}

