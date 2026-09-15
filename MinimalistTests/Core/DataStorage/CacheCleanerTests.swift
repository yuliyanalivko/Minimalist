import Foundation
import SwiftData
import Testing
@testable import Minimalist

@MainActor
struct CacheCleanerTests {
    
    private func makeRealmCategory(id: String, cachedAt: Date) -> RealmCategory {
        let entity = Category(
            id: id,
            name: "Sofas",
            thumbnailUrl: nil,
            subCategories: []
        ).toRealm()
        entity.cachedAt = cachedAt
        
        return entity
    }
    
    private func makeSwiftDataCategory(id: String, cachedAt: Date) -> SwiftDataCategory {
        let entity = SwiftDataCategory(
            entityId: id,
            name: "Sofas",
            thumbnailUrl: nil,
            subCategories: []
        )
        entity.cachedAt = cachedAt
        
        return entity
    }
    
    private func makeInMemoryContainer() throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        
        return try ModelContainer(
            for: SwiftDataCategory.self,
            SwiftDataItem.self,
            SwiftDataItemDetails.self,
            configurations: configuration
        )
    }
    
    @Test("Should delete only data older than cutoff from Realm")
    func deleteExpired_deleteStaleKeepFreshInRealm() throws {
        let database = MockDatabaseManager()
        let now = Date()
        let stale = Calendar.current.date(byAdding: .day, value: -31, to: now)!
        let fresh = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let cutoff = Calendar.current.date(byAdding: .day, value: -30, to: now)!
        
        database.objects = [
            makeRealmCategory(id: "stale", cachedAt: stale),
            makeRealmCategory(id: "fresh", cachedAt: fresh)
        ]
        
        let cleaner = CacheCleaner(realmDatabaseManager: database)
        try cleaner.deleteExpired(olderThan: cutoff)
        
        let remaining = try database.get(type: RealmCategory.self)
        
        #expect(remaining.map(\.id) == ["fresh"])
    }
    
    @Test("Should delete only data older than cutoff from SwiftData")
    func deleteExpired_deleteStaleKeepFreshInSwiftData() throws {
        let container = try makeInMemoryContainer()
        let database = SwiftDataDatabaseManager(container: container)
        let now = Date()
        let stale = Calendar.current.date(byAdding: .day, value: -31, to: now)!
        let fresh = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let cutoff = Calendar.current.date(byAdding: .day, value: -30, to: now)!
        
        try database.save([
            makeSwiftDataCategory(id: "stale", cachedAt: stale),
            makeSwiftDataCategory(id: "fresh", cachedAt: fresh)
        ])
        
        let cleaner = CacheCleaner(
            realmDatabaseManager: MockDatabaseManager(),
            swiftDataContainer: container
        )
        try cleaner.deleteExpired(olderThan: cutoff)
        
        let remaining = try database.get(type: SwiftDataCategory.self)
        
        #expect(remaining.map(\.entityId) == ["fresh"])
    }
}
