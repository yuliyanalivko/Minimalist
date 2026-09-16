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
    
    @Test("Should return only favorited items")
    func getFavorites_returnsFavoritedItems() throws {
        var favorited = item
        favorited.isFavorited = true
        let unfavorited = Item(
            id: "2",
            name: "Chair",
            category: item.category,
            subcategory: nil,
            rating: 3,
            isFavorited: false,
            isAddedToCart: false,
            price: 49.99,
            thumbnailUrl: nil
        )
        let store = try makeStore()
        
        try store.save([favorited, unfavorited])
        
        #expect(try store.getFavorites() == [favorited])
    }
    
    @Test("Should update favorited status on item and details")
    func setFavorited_updatesItemAndDetails() throws {
        let store = try makeStore()
        
        try store.save([item])
        try store.save(itemDetails)
        try store.setFavorited(id: "1", isFavorited: true)
        
        #expect(try store.getItems().first?.isFavorited == true)
        #expect(try store.getItemDetails(id: "1")?.isFavorited == true)
        #expect(try store.getFavorites().first?.id == "1")
    }
    
    @Test("Should return only items added to cart")
    func getCartItems_returnsCartItems() throws {
        var addedToCart = item
        addedToCart.isAddedToCart = true
        let notAddedToCart = Item(
            id: "2",
            name: "Chair",
            category: item.category,
            subcategory: nil,
            rating: 3,
            isFavorited: false,
            isAddedToCart: false,
            price: 49.99,
            thumbnailUrl: nil
        )
        let store = try makeStore()
        
        try store.save([addedToCart, notAddedToCart])
        
        #expect(try store.getCartItems() == [addedToCart])
    }
    
    @Test("Should update cart status on item and details")
    func setAddedToCart_updatesItemAndDetails() throws {
        let store = try makeStore()
        
        try store.save([item])
        try store.save(itemDetails)
        try store.setAddedToCart(id: "1", isAddedToCart: true)
        
        #expect(try store.getItems().first?.isAddedToCart == true)
        #expect(try store.getItemDetails(id: "1")?.isAddedToCart == true)
        #expect(try store.getCartItems().first?.id == "1")
    }
    
    @Test("Should not throw when updating a missing item")
    func setFavorited_missingItem_doesNotThrow() throws {
        let store = try makeStore()
        
        try store.setFavorited(id: "missing", isFavorited: true)
        try store.setAddedToCart(id: "missing", isAddedToCart: true)
    }
}
