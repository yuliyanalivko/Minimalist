import Foundation
import SwiftData
import Testing
@testable import Minimalist

@MainActor
struct CatalogStoreFactoryTests {
    
    private func makeContainer() throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        
        return try ModelContainer(
            for: SwiftDataCategory.self,
            SwiftDataItem.self,
            SwiftDataItemDetails.self,
            configurations: configuration
        )
    }
    
    @Test("Should return RealmCatalogStore for realm engine")
    func makeStore_realm_returnRealmCatalogStore() throws {
        let store = CatalogStoreFactory.makeStore(
            storageEngine: .realm,
            swiftDataContainer: try makeContainer()
        )
        
        #expect(store is RealmCatalogStore)
    }
    
    @Test("Should return RealmCatalogStore when SwiftData container is missing")
    func makeStore_swiftDataWithoutContainer_returnRealmCatalogStore() {
        let store = CatalogStoreFactory.makeStore(
            storageEngine: .swiftData,
            swiftDataContainer: nil
        )
        
        #expect(store is RealmCatalogStore)
    }
    
    @Test("Should return SwiftDataCatalogStore for swiftData engine with container")
    func makeStore_swiftDataWithContainer_returnSwiftDataCatalogStore() throws {
        let store = CatalogStoreFactory.makeStore(
            storageEngine: .swiftData,
            swiftDataContainer: try makeContainer()
        )
        
        #expect(store is SwiftDataCatalogStore)
    }
}
