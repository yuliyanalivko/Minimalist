import Testing
import Foundation
@testable import Minimalist

@MainActor
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
    
    private func makeViewModel(
        mockData: Data? = mockItems.data(using: .utf8),
        mockError: Error? = nil,
        favoritesMock: MockNetworkClient = MockNetworkClient(mockData: Data()),
        analyticsManager: AnalyticsManager? = nil
    ) -> ItemListViewModel {
        let catalogMock = MockNetworkClient(mockData: mockData, mockError: mockError)
        let catalogDataCoordinator = CatalogDataCoordinator(
            networkService: CatalogNetworkService(networkClient: catalogMock)
        )
        let favoritesDataCoordinator = FavoritesDataCoordinator(
            networkService: FavoritesNetworkService(networkClient: favoritesMock)
        )

        if let analyticsManager {
            return ItemListViewModel(
                id: "1",
                router: CatalogRouter(),
                catalogDataCoordinator: catalogDataCoordinator,
                favoritesDataCoordinator: favoritesDataCoordinator,
                analyticsManager: analyticsManager
            )
        }

        return ItemListViewModel(
            id: "1",
            router: CatalogRouter(),
            catalogDataCoordinator: catalogDataCoordinator,
            favoritesDataCoordinator: favoritesDataCoordinator,
        )
    }

    @Test("set isFavorite to true and log event")
    func toggleFavorite_setToTrue() async {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(analyticsManager: analyticsManager)

        vm.allItems = items
        await vm.toggleFavorite(vm.allItems[0])

        #expect(vm.allItems[0].isFavorited)

        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")

            return
        }

        #expect(name == AnalyticsEventName.addToWishlist.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == vm.allItems[0].id)
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == vm.allItems[0].name)
    }

    @Test("set isFavorite to false and log event")
    func toggleFavorite_setToFalse() async {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(analyticsManager: analyticsManager)
        vm.allItems = items
        vm.allItems[0].isFavorited = true

        await vm.toggleFavorite(vm.allItems[0])

        #expect(!vm.allItems[0].isFavorited)

        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")

            return
        }

        #expect(name == AnalyticsEventName.removeFromWishlist.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == vm.allItems[0].id)
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == vm.allItems[0].name)
    }
    
    @Test("returns allItems when search text is empty")
    func items_returnAllItems_emptySearch() {
        let vm = makeViewModel()

        vm.allItems = items
        vm.searchText = ""
        
        #expect(vm.displayedItems == vm.allItems)
    }
    
    @Test("returns allItems when search text contains only whitespaces")
    func items_returnAllItems_whitespacesSearch() {
        let vm = makeViewModel()

        vm.allItems = items
        vm.searchText = "   "
        
        #expect(vm.displayedItems == vm.allItems)
    }
    
    @Test("returns filtered items when search text is not empty")
    func items_returnFilteredItems_nonemptySearch() {
        let vm = makeViewModel()

        vm.allItems = items
        vm.searchText = "kast"
        
        #expect(vm.displayedItems == [vm.allItems[0]])
    }
    
    @Test("returns filtered items ignoring search text case")
    func items_returnFilteredItems_caseSearch() {
        let vm = makeViewModel()

        vm.allItems = items
        vm.searchText = "KAST"
        
        #expect(vm.displayedItems == [vm.allItems[0]])
    }
    
    @Test("calls logEvent with the correct search event")
    func logSearchEvent_callLogEvent() {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(analyticsManager: analyticsManager)

        vm.searchText = " tab "
        
        vm.logSearchEvent(categoryName: "Tables")
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")
            
            return
        }
        
        #expect(name == AnalyticsEventName.applySearch.rawValue)
        #expect(parameters[AnalyticsParamName.searchTerm.rawValue] as? String == "tab")
        #expect(parameters[AnalyticsParamName.categoryName.rawValue] as? String == "Tables")
    }
    
    @Test("calls logEvent with the correct viewItemList event")
    func logViewItemListEvent_callLogEvent() {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(analyticsManager: analyticsManager)

        vm.logViewItemListEvent(id: "1", name: "Tables")
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")
            
            return
        }
        
        #expect(name == AnalyticsEventName.viewItemList.rawValue)
        #expect(parameters[AnalyticsParamName.listId.rawValue] as? String == "1")
        #expect(parameters[AnalyticsParamName.listName.rawValue] as? String == "Tables")
    }
    
    @Test("Should load items from service")
    @MainActor
    func fetchCategories_setItems_onSuccess() async {
        let json = mockItems.data(using: .utf8)!
        let expected = try! JSONDecoder().decode([Item].self, from: json)
        let vm = makeViewModel(mockData: json)

        await vm.fetchItems()

        #expect(vm.allItems == expected)
        #expect(vm.isLoading == false)
        #expect(vm.state == ContentState.content(expected))
    }

    @Test("Should set error on failure")
    @MainActor
    func fetchItems_setError_onFailure() async {
        let vm = makeViewModel(mockError: URLError(.badServerResponse))

        await vm.fetchItems()

        #expect(vm.error != nil)
        #expect(vm.errorMessage == "The server returned an unexpected response. Please try again later.")
        #expect(vm.isLoading == false)
    }

    @Test("Should be loading while fetch has not completed")
    @MainActor
    func state_loading_whenIsLoadingIsTrue() {
        let vm = ItemListViewModel(id: "1", router: CatalogRouter())
        vm.isLoading = true

        #expect(vm.state == .loading)
    }

    @Test("Should be emptySearch when search has no matches")
    @MainActor
    func state_emptySearch_whenSearchHasNoMatches() {
        let vm = ItemListViewModel(id: "1", router: CatalogRouter())
        vm.isLoading = false
        vm.allItems = items
        vm.searchText = "xyz"

        #expect(vm.state == .emptySearch)
    }
    
    @Test("Should be empty when allItems is empty")
    @MainActor
    func state_empty_whenAllItemsIsEmpty() {
        let vm = ItemListViewModel(id: "1", router: CatalogRouter())
        vm.isLoading = false

        #expect(vm.state == .empty)
    }
}
