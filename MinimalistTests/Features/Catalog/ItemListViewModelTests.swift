import Testing
@testable import Minimalist

//@MainActor
struct ItemListViewModelTests {
    
    let items: [Item] = [
        Item(
            id: "1",
            name: "Vindkast",
            category: Category(
                id: "2",
                name: "Tables",
                thumbnailUrl: nil,
                subCategories: []
            ),
            subcategory: nil,
            rating: 2.5,
            isFavorited: false,
            isAddedToCart: false,
            price: 10.50,
            thumbnailUrl: "https://example.com/id/1041/5184/2916"
        ),
        Item(
            id: "2",
            name: "Solklint",
            category: Category(
                id: "2",
                name: "Tables",
                thumbnailUrl: nil,
                subCategories: []
            ),
            subcategory: nil,
            rating: 5.5,
            isFavorited: false,
            isAddedToCart: false,
            price: 20.50,
            thumbnailUrl: "https://example.com/id/1041/5184/2916"
        )
    ]
    
    @Test("set isFavorite to true")
    func toggleFavorite_setToTrue() {
        let vm = ItemListViewModel(router: CatalogRouter())
        
        vm.allItems = items
        vm.toggleFavorite(vm.allItems[0])
        
        #expect(vm.allItems[0].isFavorited)
    }
    
    @Test("set isFavorite to false")
    func toggleFavorite_setToFalse() {
        let vm = ItemListViewModel(router: CatalogRouter())
        
        vm.allItems = items
        vm.allItems[0].isFavorited = true
        vm.toggleFavorite(vm.allItems[0])
        
        #expect(!vm.allItems[0].isFavorited)
    }
    
    @Test("returns allItems when search text is empty")
    func items_returnAllItems_emptySearch() {
        let vm = ItemListViewModel(router: CatalogRouter())
        
        vm.allItems = items
        vm.searchText = ""
        
        #expect(vm.items == vm.allItems)
    }
    
    @Test("returns allItems when search text contains only whitespaces")
    func items_returnAllItems_whitespacesSearch() {
        let vm = ItemListViewModel(router: CatalogRouter())
        
        vm.allItems = items
        vm.searchText = "   "
        
        #expect(vm.items == vm.allItems)
    }
    
    @Test("returns filtered items when search text is not empty")
    func items_returnFilteredItems_nonemptySearch() {
        let vm = ItemListViewModel(router: CatalogRouter())
        
        vm.allItems = items
        vm.searchText = "kast"
        
        #expect(vm.items == [vm.allItems[0]])
    }
    
    @Test("returns filtered items ignoring search text case")
    func items_returnFilteredItems_caseSearch() {
        let vm = ItemListViewModel(router: CatalogRouter())
        
        vm.allItems = items
        vm.searchText = "KAST"
        
        #expect(vm.items == [vm.allItems[0]])
    }
    
}
