import Foundation
import SwiftData
import Testing
@testable import Minimalist

@MainActor
struct SwiftDataCatalogStoreTests {
    
    private func makeStore() throws -> SwiftDataCatalogStore {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: SwiftDataCategory.self,
            SwiftDataItem.self,
            SwiftDataItemDetails.self,
            configurations: configuration
        )
        
        return SwiftDataCatalogStore(container: container)
    }
    
    @Test("Should save and get categories")
    func saveAndGetCategories() throws {
        let store = try makeStore()
        
        try store.save([category])
        let result = try store.getCategories()
        
        #expect(result == [category])
    }
    
    @Test("Should save and get items")
    func saveAndGetItems() throws {
        let store = try makeStore()
        
        try store.save([item])
        let result = try store.getItems()
        
        #expect(result == [item])
    }
    
    @Test("Should save and get item details by id")
    func saveAndGetItemDetails() throws {
        let store = try makeStore()
        
        try store.save(itemDetails)
        let result = try store.getItemDetails(id: "1")
        
        #expect(result == itemDetails)
    }
    
    @Test("Should return nil when item details are missing")
    func getItemDetails_missing_returnsNil() throws {
        let store = try makeStore()
        
        let result = try store.getItemDetails(id: "missing")
        
        #expect(result == nil)
    }
    
    @Test("Should update existing categories by id")
    func save_withSameId_updatesCategory() throws {
        let store = try makeStore()
        let updated = Category(
            id: "1",
            name: "Updated Sofas",
            thumbnailUrl: nil,
            subCategories: []
        )
        
        try store.save([category])
        try store.save([updated])
        
        let result = try store.getCategories()
        
        #expect(result == [updated])
    }
}
