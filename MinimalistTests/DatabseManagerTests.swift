import Testing
import Foundation
import RealmSwift
@testable import Minimalist

@MainActor
struct DatabaseManagerTests {

    private func makeManager() throws -> DatabaseManager {
        let config = Realm.Configuration(
            inMemoryIdentifier: UUID().uuidString,
            objectTypes: [CategoryEntity.self, SubCategoryEntity.self]
        )

        return DatabaseManager(configuration: config)
    }

    @Test("Should save and get data")
    func save_thenGet_returnSavedObjects() throws {
        let manager = try makeManager()
        let entity = Category(
            id: "1",
            name: "Sofas",
            thumbnailUrl: nil,
            subCategories: []
        ).toEntity()

        try manager.save(entity)
        let result = try manager.get(type: CategoryEntity.self)

        #expect(result.count == 1)
        #expect(result.first?.id == "1")
        #expect(result.first?.name == "Sofas")
    }

    @Test("Should update existing object by primary key")
    func save_withSameId_updateObject() throws {
        let manager = try makeManager()
        try manager.save(Category(id: "1", name: "Sofas", thumbnailUrl: nil, subCategories: []).toEntity())
        try manager.save(Category(id: "1", name: "Updated", thumbnailUrl: nil, subCategories: []).toEntity())

        let result = try manager.get(type: CategoryEntity.self)

        #expect(result.count == 1)
        #expect(result.first?.name == "Updated")
    }

    @Test("Should get data by id")
    func get_byId_returnObject() throws {
        let manager = try makeManager()
        try manager.save(Category(id: "2", name: "Tables", thumbnailUrl: nil, subCategories: []).toEntity())
        
        let result = try manager.get(type: CategoryEntity.self, id: "2")

        #expect(result?.name == "Tables")
    }

    @Test("Should delete by id")
    func delete_byId_removeObject() throws {
        let manager = try makeManager()
        try manager.save(Category(id: "1", name: "Sofas", thumbnailUrl: nil, subCategories: []).toEntity())

        try manager.delete(type: CategoryEntity.self, id: "1")
        let result = try manager.get(type: CategoryEntity.self)

        #expect(result.isEmpty)
    }

    @Test("Should delete all of type")
    func delete_type_removeAll() throws {
        let manager = try makeManager()
        try manager.save([
            Category(id: "1", name: "Sofas", thumbnailUrl: nil, subCategories: []).toEntity(),
            Category(id: "2", name: "Tables", thumbnailUrl: nil, subCategories: []).toEntity()
        ])

        try manager.delete(type: CategoryEntity.self)

        #expect(try manager.get(type: CategoryEntity.self).isEmpty)
    }
}

