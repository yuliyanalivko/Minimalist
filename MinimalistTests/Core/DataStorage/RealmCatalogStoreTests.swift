import Foundation
import Testing
@testable import Minimalist

struct RealmCatalogStoreTests {
    
    private func makeStore(
        database: MockDatabaseManager = MockDatabaseManager()
    ) -> RealmCatalogStore {
        RealmCatalogStore(databaseManager: database)
    }
    
    @Test("Should save and get categories")
    func saveAndGetCategories() throws {
        let store = makeStore()
        
        try store.save([category])
        let result = try store.getCategories()
        
        #expect(result == [category])
    }
    
    @Test("Should save and get items")
    func saveAndGetItems() throws {
        let store = makeStore()
        
        try store.save([item])
        let result = try store.getItems()
        
        #expect(result == [item])
    }
    
    @Test("Should save and get item details by id")
    func saveAndGetItemDetails() throws {
        let store = makeStore()
        
        try store.save(itemDetails)
        let result = try store.getItemDetails(id: "1")
        
        #expect(result == itemDetails)
    }
    
    @Test("Should return nil when item details are missing")
    func getItemDetails_missing_returnsNil() throws {
        let store = makeStore()
        
        let result = try store.getItemDetails(id: "missing")
        
        #expect(result == nil)
    }
    
    @Test("Should propagate get errors")
    func getCategories_propagatesError() {
        let database = MockDatabaseManager()
        database.getError = URLError(.badServerResponse)
        let store = RealmCatalogStore(databaseManager: database)
        
        #expect(throws: URLError.self) {
            try store.getCategories()
        }
    }
}
