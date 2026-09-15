import Foundation
import SwiftData
import Testing
@testable import Minimalist

@MainActor
struct SwiftDataDatabaseManagerTests {
    
    private func makeManager() throws -> SwiftDataDatabaseManager {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: SwiftDataCategory.self,
            SwiftDataItem.self,
            SwiftDataItemDetails.self,
            configurations: configuration
        )
        
        return SwiftDataDatabaseManager(container: container)
    }
    
    private func makeCategory(
        id: String,
        name: String = "Sofas",
        cachedAt: Date = Date()
    ) -> SwiftDataCategory {
        let entity = SwiftDataCategory(
            entityId: id,
            name: name,
            thumbnailUrl: nil,
            subCategories: []
        )
        entity.cachedAt = cachedAt
        
        return entity
    }
    
    @Test("Should save and get data")
    func save_thenGet_returnSavedObjects() throws {
        let manager = try makeManager()
        try manager.save(makeCategory(id: "1"))
        
        let result = try manager.get(type: SwiftDataCategory.self)
        
        #expect(result.count == 1)
        #expect(result.first?.entityId == "1")
        #expect(result.first?.name == "Sofas")
    }
    
    @Test("Should update existing object by entity id")
    func save_withSameId_updateObject() throws {
        let manager = try makeManager()
        try manager.save(makeCategory(id: "1", name: "Sofas"))
        try manager.save(makeCategory(id: "1", name: "Updated"))
        
        let result = try manager.get(type: SwiftDataCategory.self)
        
        #expect(result.count == 1)
        #expect(result.first?.name == "Updated")
    }
    
    @Test("Should get data by id")
    func get_byId_returnObject() throws {
        let manager = try makeManager()
        try manager.save(makeCategory(id: "2", name: "Tables"))
        
        let result = try manager.get(type: SwiftDataCategory.self, id: "2")
        
        #expect(result?.name == "Tables")
    }
    
    @Test("Should delete by id")
    func delete_byId_removeObject() throws {
        let manager = try makeManager()
        try manager.save(makeCategory(id: "1"))
        
        try manager.delete(type: SwiftDataCategory.self, id: "1")
        let result = try manager.get(type: SwiftDataCategory.self)
        
        #expect(result.isEmpty)
    }
    
    @Test("Should delete all of type")
    func delete_type_removeAll() throws {
        let manager = try makeManager()
        try manager.save([
            makeCategory(id: "1"),
            makeCategory(id: "2", name: "Tables")
        ])
        
        try manager.delete(type: SwiftDataCategory.self)
        
        #expect(try manager.get(type: SwiftDataCategory.self).isEmpty)
    }
    
    @Test("Should delete only data older than cutoff")
    func delete_olderThan_removesStaleKeepsFresh() throws {
        let manager = try makeManager()
        let now = Date()
        let stale = Calendar.current.date(byAdding: .day, value: -31, to: now)!
        let fresh = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let cutoff = Calendar.current.date(byAdding: .day, value: -30, to: now)!
        
        try manager.save([
            makeCategory(id: "stale", cachedAt: stale),
            makeCategory(id: "fresh", cachedAt: fresh)
        ])
        
        try manager.delete(type: SwiftDataCategory.self, olderThan: cutoff)
        
        let remaining = try manager.get(type: SwiftDataCategory.self)
        
        #expect(remaining.map(\.entityId) == ["fresh"])
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
    
    @Test("Should sort results by name")
    func get_sortByName_returnsAlphabeticalOrder() throws {
        let manager = try makeManager()
        try manager.save([
            makeCategory(id: "1", name: "Tables"),
            makeCategory(id: "2", name: "Sofas")
        ])
        
        let result = try manager.get(type: SwiftDataCategory.self, sort: .name)
        
        #expect(result.map(\.name) == ["Sofas", "Tables"])
    }
    
    @Test("Should update an existing object and refresh cachedAt")
    func update_existingObject_appliesChanges() throws {
        let manager = try makeManager()
        let originalDate = Date(timeIntervalSince1970: 1)
        try manager.save(makeCategory(id: "1", cachedAt: originalDate))
        
        try manager.update(type: SwiftDataCategory.self, id: "1") { stored in
            stored.name = "Updated"
        }
        
        let result = try manager.get(type: SwiftDataCategory.self, id: "1")
        
        #expect(result?.name == "Updated")
        #expect(result?.cachedAt ?? originalDate > originalDate)
    }
    
    @Test("Should not throw when updating a missing object")
    func update_missingObject_doesNotThrow() throws {
        let manager = try makeManager()
        
        try manager.update(type: SwiftDataCategory.self, id: "missing") { stored in
            stored.name = "Updated"
        }
    }
}
