import Testing
@testable import Minimalist

@MainActor
struct ItemListViewModelTests {
    
    class SpyViewModel: ItemListViewModel {

        private(set) var loggedEvents: [AnalyticsEvent] = []

        override func logEvent(_ event: AnalyticsEvent) {
            loggedEvents.append(event)
        }
    }
    
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
    
    @Test("set isFavorite to true and log event")
    func toggleFavorite_setToTrue() {
        let vm = SpyViewModel(router: CatalogRouter())
        
        vm.allItems = items
        vm.toggleFavorite(vm.allItems[0])
        
        #expect(vm.allItems[0].isFavorited)
        #expect(vm.loggedEvents == [AnalyticsEvent.addToWishlist(id: vm.allItems[0].id, name: vm.allItems[0].name)])
    }
    
    @Test("set isFavorite to false and log event")
    func toggleFavorite_setToFalse() {
        let vm = SpyViewModel(router: CatalogRouter())
        
        vm.allItems = items
        vm.allItems[0].isFavorited = true
        vm.toggleFavorite(vm.allItems[0])
        
        #expect(!vm.allItems[0].isFavorited)
        #expect(vm.loggedEvents == [AnalyticsEvent.removeFromWishlist(id: vm.allItems[0].id, name: vm.allItems[0].name)])
    }
    
    @Test("returns allItems when search text is empty")
    func items_returnAllItems_emptySearch() {
        let vm = ItemListViewModel(router: CatalogRouter())
        
        vm.allItems = items
        vm.searchText = ""
        
        #expect(vm.displayedItems == vm.allItems)
    }
    
    @Test("returns allItems when search text contains only whitespaces")
    func items_returnAllItems_whitespacesSearch() {
        let vm = ItemListViewModel(router: CatalogRouter())
        
        vm.allItems = items
        vm.searchText = "   "
        
        #expect(vm.displayedItems == vm.allItems)
    }
    
    @Test("returns filtered items when search text is not empty")
    func items_returnFilteredItems_nonemptySearch() {
        let vm = ItemListViewModel(router: CatalogRouter())
        
        vm.allItems = items
        vm.searchText = "kast"
        
        #expect(vm.displayedItems == [vm.allItems[0]])
    }
    
    @Test("returns filtered items ignoring search text case")
    func items_returnFilteredItems_caseSearch() {
        let vm = ItemListViewModel(router: CatalogRouter())
        
        vm.allItems = items
        vm.searchText = "KAST"
        
        #expect(vm.displayedItems == [vm.allItems[0]])
    }
    
    @Test("calls logEvent with the correct search event")
    func logSearchEvent_callLogEvent() {
        let vm = SpyViewModel(router: CatalogRouter())

        vm.searchText = " tab "
        
        vm.logSearchEvent(categoryName: "Tables")
        
        #expect(vm.loggedEvents == [AnalyticsEvent.applySearch(searchTerm: "tab", categoryName: "Tables")])
    }
    
    @Test("calls logEvent with the correct viewItemList event")
    func logViewItemListEvent_callLogEvent() {
        let vm = SpyViewModel(router: CatalogRouter())
        
        vm.logViewItemListEvent(id: "1", name: "Tables")
        
        #expect(vm.loggedEvents == [AnalyticsEvent.viewItemList(id: "1", name: "Tables")])
    }
}
