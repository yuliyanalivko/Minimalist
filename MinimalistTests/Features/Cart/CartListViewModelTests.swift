import Testing
import Foundation
@testable import Minimalist
import SwiftUI

@MainActor
struct CartListViewModelTests {
    
    let items: [Item] = [
        Item(
            id: "1",
            name: "Vindkast",
            category: Category(
                id: "1",
                name: "Tables",
                thumbnailUrl: nil,
                subCategories: []
            ),
            subcategory: nil,
            rating: 2.5,
            isFavorited: false,
            isAddedToCart: true,
            price: 10.50,
            thumbnailUrl: "https://example.com/id/1041/500/500"
        ),
        Item(
            id: "2",
            name: "Solklint",
            category: Category(
                id: "1",
                name: "Tables",
                thumbnailUrl: nil,
                subCategories: []
            ),
            subcategory: nil,
            rating: 5.5,
            isFavorited: false,
            isAddedToCart: true,
            price: 20.50,
            thumbnailUrl: "https://example.com/id/1041/500/500"
        )
    ]
    
    private func makeViewModel(
        mockData: Data? = mockItems.data(using: .utf8),
        mockError: Error? = nil,
        database: MockDatabaseManager = MockDatabaseManager(),
        analyticsManager: AnalyticsManager? = nil
    ) -> CartListViewModel {
        let cartMock = MockNetworkClient(mockData: mockData, mockError: mockError)
        let cartDataCoordinator = CartDataCoordinator(
            networkService: CartNetworkService(networkClient: cartMock),
            storeResolver: { RealmStore(databaseManager: database) }
        )
        
        return CartListViewModel(
            router: CartRouter(),
            cartDataCoordinator: cartDataCoordinator,
            analyticsManager: analyticsManager
        )
    }
    
    @Test("Should return allItems when search text is empty")
    func displayedItems_returnAllItems_emptySearch() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.searchText = ""
        
        #expect(vm.displayedItems == vm.allItems)
    }
    
    @Test("Should return allItems when search text contains only whitespaces")
    func displayedItems_returnAllItems_whitespacesSearch() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.searchText = "   "
        
        #expect(vm.displayedItems == vm.allItems)
    }
    
    @Test("Should return filtered items when search text is not empty")
    func displayedItems_returnFilteredItems_nonemptySearch() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.searchText = "kast"
        
        #expect(vm.displayedItems == [vm.allItems[0]])
    }
    
    @Test("Should return filtered items ignoring search text case")
    func displayedItems_returnFilteredItems_caseSearch() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.searchText = "KAST"
        
        #expect(vm.displayedItems == [vm.allItems[0]])
    }
    
    @Test("Should be loading while fetch has not completed")
    func state_loading_whenIsLoadingIsTrue() {
        let vm = makeViewModel()
        vm.isLoading = true
        
        #expect(vm.state == .loading)
    }
    
    @Test("Should be empty when allItems is empty")
    func state_empty_whenAllItemsIsEmpty() {
        let vm = makeViewModel()
        vm.isLoading = false
        
        #expect(vm.state == .empty)
    }
    
    @Test("Should be emptySearch when search has no matches")
    func state_emptySearch_whenSearchHasNoMatches() {
        let vm = makeViewModel()
        vm.isLoading = false
        vm.allItems = items
        vm.searchText = "xyz"
        
        #expect(vm.state == .emptySearch)
    }
    
    @Test("Should be content when items remain")
    func state_content_whenItemsRemain() {
        let vm = makeViewModel()
        vm.isLoading = false
        vm.allItems = items
        
        #expect(vm.state == .content(items))
    }
    
    @Test("Should load cart items from network when cache is empty")
    func fetchCartItems_networkSuccess_emptyCache() async {
        let json = mockItems.data(using: .utf8)!
        let expected = try! JSONDecoder().decode([Item].self, from: json)
        let vm = makeViewModel(mockData: json)
        
        await vm.fetchCartItems()
        
        #expect(vm.allItems == expected)
        #expect(vm.isLoading == false)
        #expect(vm.error == nil)
    }
    
    @Test("Should set error when network fails and cache is empty")
    func fetchCartItems_networkFailure_emptyCache() async {
        let vm = makeViewModel(mockError: URLError(.badServerResponse))
        
        await vm.fetchCartItems()
        
        #expect(vm.allItems.isEmpty)
        #expect(vm.error != nil)
        #expect(vm.isLoading == false)
    }
    
    @Test("Should refresh cart items after showing cache")
    func fetchCartItems_cacheThenNetwork() async {
        let cached = items
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toRealm() }
        let json = mockItems.data(using: .utf8)!
        let network = try! JSONDecoder().decode([Item].self, from: json)
        let vm = makeViewModel(mockData: json, database: database)
        
        await vm.fetchCartItems()
        
        #expect(vm.allItems == network)
        #expect(vm.isLoading == false)
    }
    
    @Test("Should keep cached cart items when network fails")
    func fetchCartItems_networkFailure_keepCache() async {
        let cached = items
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toRealm() }
        let vm = makeViewModel(mockError: URLError(.badServerResponse), database: database)
        
        await vm.fetchCartItems()
        
        #expect(vm.allItems == cached.sorted(by: \.name))
        #expect(vm.isLoading == false)
        #expect(vm.error != nil)
    }
    
    @Test("Should resize thumbnail URLs when fetching cart items")
    func fetchCartItems_resizeThumbnailUrls() async {
        let json = """
        [
          {
            "id": "1",
            "name": "Vindkast",
            "category": null,
            "subcategory": null,
            "rating": 2.5,
            "isFavorited": false,
            "isAddedToCart": true,
            "price": 10.50,
            "thumbnailUrl": "https://example.com/id/1041/200/200"
          }
        ]
        """.data(using: .utf8)!
        let vm = makeViewModel(mockData: json)
        
        await vm.fetchCartItems()
        
        #expect(vm.allItems.first?.thumbnailUrl == "https://example.com/id/1041/500/500")
    }
    
    @Test("Should remove item from cart and log event")
    func removeFromCart_removeItemAndLogsEvent() async {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let database = MockDatabaseManager()
        database.objects = items.map { $0.toRealm() }
        let vm = makeViewModel(database: database, analyticsManager: analyticsManager)
        vm.allItems = items
        let removed = vm.allItems[0]
        
        await vm.removeFromCart(removed)
        
        #expect(vm.allItems.map(\.id) == ["2"])
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")
            
            return
        }
        
        #expect(name == AnalyticsEventName.removeFromCart.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == removed.id)
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == removed.name)
    }
    
    @Test("Should keep the item when removing from cart fails")
    func removeFromCart_networkFailure_keepItem() async {
        let vm = makeViewModel(mockError: URLError(.badServerResponse))
        vm.allItems = items
        
        await vm.removeFromCart(vm.allItems[0])
        
        #expect(vm.allItems.map(\.id) == ["1", "2"])
        #expect(vm.error != nil)
    }
    
    @Test("Should navigate to item details on click")
    func handleItemClick_navigatesToItemDetails() {
        let vm = makeViewModel()
        
        vm.handleItemClick(item: items[0])
        
        #expect(vm.router.path.count == 1)
    }
    
    @Test("Should call logEvent with the correct search event")
    func logSearchEvent_callLogEvent() {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(analyticsManager: analyticsManager)
        vm.searchText = " tab "
        
        vm.logSearchEvent()
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")
            
            return
        }
        
        #expect(name == AnalyticsEventName.applySearch.rawValue)
        #expect(parameters[AnalyticsParamName.searchTerm.rawValue] as? String == "tab")
    }
    
    @Test("Should not log a search event for empty search text")
    func logSearchEvent_emptySearch_doNotLog() {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(analyticsManager: analyticsManager)
        vm.searchText = "   "
        
        vm.logSearchEvent()
        
        #expect(consumer.loggedEvent == nil)
    }
}
