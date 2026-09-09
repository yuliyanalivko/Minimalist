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
                id: "1",
                name: "Tables",
                thumbnailUrl: nil,
                subCategories: []
            ),
            subcategory: SubCategory(id: "dining", name: "Dining", thumbnailUrl: nil, iconName: nil),
            rating: 2.5,
            isFavorited: false,
            isAddedToCart: false,
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
            subcategory: SubCategory(id: "lighting", name: "Lighting", thumbnailUrl: nil, iconName: nil),
            rating: 5.5,
            isFavorited: false,
            isAddedToCart: false,
            price: 20.50,
            thumbnailUrl: "https://example.com/id/1041/500/500"
        )
    ]
    
    private func makeViewModel(
        mockData: Data? = mockItems.data(using: .utf8),
        mockError: Error? = nil,
        favoritesMock: MockNetworkClient = MockNetworkClient(mockData: Data()),
        database: MockDatabaseManager = MockDatabaseManager(),
        analyticsManager: AnalyticsManager? = nil
    ) -> ItemListViewModel {
        let catalogMock = MockNetworkClient(mockData: mockData, mockError: mockError)
        let catalogDataCoordinator = CatalogDataCoordinator(
            networkService: CatalogNetworkService(networkClient: catalogMock),
            storeResolver: { RealmStore(databaseManager: database) }
        )
        let favoritesDataCoordinator = FavoritesDataCoordinator(
            networkService: FavoritesNetworkService(networkClient: favoritesMock),
            storeResolver: { RealmStore(databaseManager: database) }
        )

        if let analyticsManager {
            return ItemListViewModel(
                categoryId: "1",
                router: CatalogRouter(),
                catalogDataCoordinator: catalogDataCoordinator,
                favoritesDataCoordinator: favoritesDataCoordinator,
                analyticsManager: analyticsManager
            )
        }

        return ItemListViewModel(
            categoryId: "1",
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

    @Test("Should load items from network when cache is empty")
    @MainActor
    func fetchItems_networkSuccess_emptyCache() async {
        let json = mockItems.data(using: .utf8)!
        let expected = try! JSONDecoder().decode([Item].self, from: json)
        let vm = makeViewModel(mockData: json)

        await vm.fetchItems()

        #expect(vm.allItems == expected)
        #expect(vm.isLoading == false)
        #expect(vm.error == nil)
    }
    
    @Test("Should set error when network fails and cache is empty")
    @MainActor
    func fetchItems_networkFailure_emptyCache() async {
        let vm = makeViewModel(mockError: URLError(.badServerResponse))

        await vm.fetchItems()

        #expect(vm.allItems.isEmpty)
        #expect(vm.error != nil)
        #expect(vm.isLoading == false)
    }
    
    @Test("Should refresh items after showing cache")
    @MainActor
    func fetchItems_cacheThenNetwork() async {
        let cached = items
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toRealm() }

        let json = mockItems.data(using: .utf8)!
        let network = try! JSONDecoder().decode([Item].self, from: json)
        let vm = makeViewModel(mockData: json, database: database)

        await vm.fetchItems()

        #expect(vm.allItems == network)
        #expect(vm.isLoading == false)
    }
    
    @Test("Should keep cached items when network fails")
    @MainActor
    func fetchItems_networkFailure_keepsCache() async {
        let cached = items
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toRealm() }

        let vm = makeViewModel(mockError: URLError(.badServerResponse), database: database)

        await vm.fetchItems()

        #expect(vm.allItems == cached.sorted { $0.name < $1.name })
        #expect(vm.isLoading == false)
        #expect(vm.error != nil)
    }

    @Test("Should be loading while fetch has not completed")
    @MainActor
    func state_loading_whenIsLoadingIsTrue() {
        let vm = ItemListViewModel(categoryId: "1", router: CatalogRouter())
        vm.isLoading = true

        #expect(vm.state == .loading)
    }

    @Test("Should be emptySearch when search has no matches")
    @MainActor
    func state_emptySearch_whenSearchHasNoMatches() {
        let vm = ItemListViewModel(categoryId: "1", router: CatalogRouter())
        vm.isLoading = false
        vm.allItems = items
        vm.searchText = "xyz"

        #expect(vm.state == .emptySearch)
    }
    
    @Test("Should be empty when allItems is empty")
    @MainActor
    func state_empty_whenAllItemsIsEmpty() {
        let vm = ItemListViewModel(categoryId: "1", router: CatalogRouter())
        vm.isLoading = false

        #expect(vm.state == .empty)
    }
    
    @Test("Should sort items by name ascending")
    func updateSorting_sortByNameForward() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.sortBySheetViewModel = SortBySheetViewModel(selectedOption: .name, selectedOrder: .forward)
        
        #expect(vm.displayedItems.map(\.name) == ["Solklint", "Vindkast"])
    }
    
    @Test("Should sort items by name descending")
    func updateSorting_sortByNameReverse() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.sortBySheetViewModel = SortBySheetViewModel(selectedOption: .name, selectedOrder: .reverse)
        
        #expect(vm.displayedItems.map(\.name) == ["Vindkast", "Solklint"])
    }
    
    @Test("Should sort items by price ascending")
    func updateSorting_sortByPriceForward() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.sortBySheetViewModel = SortBySheetViewModel(selectedOption: .price, selectedOrder: .forward)
        
        #expect(vm.displayedItems.map(\.id) == ["1", "2"])
    }
    
    @Test("Should sort items by price descending")
    func updateSorting_sortByPriceReverse() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.sortBySheetViewModel = SortBySheetViewModel(selectedOption: .price, selectedOrder: .reverse)
        
        #expect(vm.displayedItems.map(\.id) == ["2", "1"])
    }
    
    @Test("Should sort items by rating ascending")
    func updateSorting_sortByRatingForward() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.sortBySheetViewModel = SortBySheetViewModel(selectedOption: .rating, selectedOrder: .forward)
        
        #expect(vm.displayedItems.map(\.id) == ["1", "2"])
    }
    
    @Test("Should sort items by rating descending")
    func updateSorting_sortByRatingReverse() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.sortBySheetViewModel = SortBySheetViewModel(selectedOption: .rating, selectedOrder: .reverse)
        
        #expect(vm.displayedItems.map(\.id) == ["2", "1"])
    }
    
    @Test("Should apply sorting after search filtering")
    func updateSorting_sortFilteredItems() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.searchText = "int"
        vm.sortBySheetViewModel = SortBySheetViewModel(selectedOption: .name, selectedOrder: .forward)
        
        #expect(vm.displayedItems.map(\.name) == ["Solklint"])
    }
    
    @Test("Should clear sorting when option and order are nil")
    func updateSorting_clearSorting() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.sortBySheetViewModel = SortBySheetViewModel(selectedOption: nil, selectedOrder: nil)
        
        #expect(vm.displayedItems == items)
    }
    
    @Test("Should present the sorting sheet and initialize sortBySheetViewModel")
    func triggerSortBySheet_initializeSortBySheetViewModelAndPresentSheet() {
        let vm = makeViewModel()
        
        vm.triggerSortBySheet()
        
        #expect(vm.activeSheet == .sort)
        #expect(vm.sortBySheetViewModel != nil)
    }
    
    @Test("Should present the filter sheet and initialize filterBySheetViewModel once")
    func triggerFilterSheet_initializeFilterBySheetViewModelAndPresentSheet() {
        let vm = makeViewModel()
        vm.allItems = items
        
        vm.triggerFilterSheet()
        let firstInstance = vm.filterBySheetViewModel
        
        vm.triggerFilterSheet()
        
        #expect(vm.activeSheet == .filter)
        #expect(vm.filterBySheetViewModel != nil)
        #expect(vm.filterBySheetViewModel === firstInstance)
        #expect(vm.filterBySheetViewModel?.priceBounds == 10...21)
        #expect(vm.filterBySheetViewModel?.categories.count == 2)
    }
    
    @Test("Should seed the filter sheet with the applied state on every presentation")
    func triggerFilterSheet_seedsDraftFromAppliedState() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.triggerFilterSheet()
        
        vm.filterBySheetViewModel?.minPrice = 20
        vm.filterBySheetViewModel?.apply()
        vm.triggerFilterSheet()
        
        #expect(vm.filterBySheetViewModel?.draftFilterState == vm.appliedFilterState)
        #expect(vm.filterBySheetViewModel?.isApplyDisabled == true)
    }
    
    @Test("Should discard draft changes that were never applied")
    func triggerFilterSheet_discardsUnappliedDraft() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.triggerFilterSheet()
        
        vm.filterBySheetViewModel?.minPrice = 20
        vm.filterBySheetViewModel?.expandedOptions = [.rating]
        vm.triggerFilterSheet()
        
        #expect(vm.filterBySheetViewModel?.draftFilterState.priceRange == nil)
        #expect(vm.filterBySheetViewModel?.expandedOptions.isEmpty == true)
    }
    
    @Test("Should not filter displayedItems while filter values change")
    func displayedItems_notFilteredUntilApply() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.triggerFilterSheet()
        
        vm.filterBySheetViewModel?.minPrice = 20
        
        #expect(vm.displayedItems == items)
        #expect(vm.appliedFilterState == nil)
    }
    
    @Test("Should filter displayedItems after Apply")
    func displayedItems_filteredOnApply() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.triggerFilterSheet()
        
        vm.filterBySheetViewModel?.minPrice = 20
        vm.filterBySheetViewModel?.apply()
        
        #expect(vm.displayedItems.map(\.id) == ["2"])
        #expect(vm.appliedFilterState?.priceRange == 20...21)
    }
    
    @Test("Should clear the applied state when every filter is reset")
    func applyFilters_clearsAppliedStateWhenEmpty() {
        let vm = makeViewModel()
        vm.allItems = items
        
        vm.applyFilters(FilterState(minRating: 5))
        vm.applyFilters(FilterState())
        
        #expect(vm.appliedFilterState == nil)
        #expect(vm.displayedItems == items)
    }
    
    @Test("Should filter items by category")
    func displayedItems_filterByCategory() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.triggerFilterSheet()
        
        vm.filterBySheetViewModel?.draftFilterState.categoryId = "dining"
        vm.filterBySheetViewModel?.apply()
        
        #expect(vm.displayedItems.map(\.id) == ["1"])
    }
    
    @Test("Should filter items by minimum rating")
    func displayedItems_filterByRating() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.triggerFilterSheet()
        
        vm.filterBySheetViewModel?.draftFilterState.minRating = 5
        vm.filterBySheetViewModel?.apply()
        
        #expect(vm.displayedItems.map(\.id) == ["2"])
    }
    
    @Test("Should apply sorting after filters")
    func displayedItems_sortFilteredItems() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.triggerFilterSheet()
        
        vm.filterBySheetViewModel?.maxPrice = 15
        vm.filterBySheetViewModel?.apply()
        vm.sortBySheetViewModel = SortBySheetViewModel(selectedOption: .name, selectedOrder: .forward)
        
        #expect(vm.displayedItems.map(\.name) == ["Vindkast"])
    }
    
    @Test("Should keep all categories available after a category filter is applied")
    func subcategories_useAllItemsNotDisplayedItems() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.triggerFilterSheet()
        
        vm.filterBySheetViewModel?.draftFilterState.categoryId = "dining"
        vm.filterBySheetViewModel?.apply()
        
        #expect(Set(vm.subcategories.map(\.id)) == ["dining", "lighting"])
    }
    
    @Test("Should keep filters valid when the price bounds change after loading")
    func displayedItems_filtersSurvivePriceBoundsChange() {
        let vm = makeViewModel()
        vm.triggerFilterSheet()
        
        vm.filterBySheetViewModel?.apply()
        vm.allItems = items
        
        #expect(vm.appliedFilterState == nil)
        #expect(vm.displayedItems == items)
    }
    
    @Test("Should be emptyFilter when filters match no items")
    func state_emptyFilter_whenFiltersHaveNoMatches() {
        let vm = makeViewModel()
        vm.isLoading = false
        vm.allItems = items
        
        vm.applyFilters(FilterState(minRating: 6))
        
        #expect(vm.state == .emptyFilter)
    }
    
    @Test("Should prefer emptySearch when search and filters both match nothing")
    func state_emptySearch_takesPrecedenceOverEmptyFilter() {
        let vm = makeViewModel()
        vm.isLoading = false
        vm.allItems = items
        vm.searchText = "xyz"
        
        vm.applyFilters(FilterState(minRating: 6))
        
        #expect(vm.state == .emptySearch)
    }
    
    @Test("Should be content when filtered items remain")
    func state_content_whenFilteredItemsRemain() {
        let vm = makeViewModel()
        vm.isLoading = false
        vm.allItems = items
        
        vm.applyFilters(FilterState(minRating: 2))
        
        #expect(vm.state == .content(items))
    }
    
    @Test("Should include an item whose rating equals the minimum")
    func displayedItems_filterByRating_includesEqualRating() {
        let vm = makeViewModel()
        vm.allItems = items
        
        vm.applyFilters(FilterState(minRating: 2.5))
        
        #expect(vm.displayedItems.map(\.id) == ["1", "2"])
    }
    
    @Test("Should apply category, price, and rating filters together")
    func displayedItems_combinedFilters() {
        let vm = makeViewModel()
        vm.allItems = items
        
        vm.applyFilters(FilterState(categoryId: "dining", priceRange: 10...15, minRating: 2))
        
        #expect(vm.displayedItems.map(\.id) == ["1"])
        
        vm.applyFilters(FilterState(categoryId: "dining", minRating: 5))
        
        #expect(vm.displayedItems.isEmpty)
    }
    
    @Test("Should apply search before filters")
    func displayedItems_searchThenFilter() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.searchText = "int"
        
        vm.applyFilters(FilterState(minRating: 5))
        
        #expect(vm.displayedItems.map(\.name) == ["Solklint"])
        
        vm.searchText = "kast"
        
        #expect(vm.displayedItems.isEmpty)
        #expect(vm.state == .emptySearch)
    }
    
    @Test("Should round price bounds down and up")
    func priceBounds_roundedOutward() {
        let vm = makeViewModel()
        
        #expect(vm.priceBounds == 0...0)
        
        vm.allItems = items
        
        #expect(vm.priceBounds == 10...21)
    }
    
    @Test("Should reuse the sort sheet view model on later presentations")
    func triggerSortBySheet_reusesExistingViewModel() {
        let vm = makeViewModel()
        
        vm.triggerSortBySheet()
        let firstInstance = vm.sortBySheetViewModel
        vm.sortBySheetViewModel?.updateSelection(order: .forward, option: .price)
        
        vm.triggerSortBySheet()
        
        #expect(vm.activeSheet == .sort)
        #expect(vm.sortBySheetViewModel === firstInstance)
        #expect(vm.sortBySheetViewModel?.selectedOption == .price)
    }
    
    @Test("Should keep an applied price filter after the item list changes")
    func displayedItems_priceFilterSurvivesItemListChange() {
        let vm = makeViewModel()
        vm.allItems = items
        vm.applyFilters(FilterState(priceRange: 20...21))
        
        vm.allItems = items + [
            Item(
                id: "3",
                name: "Extra",
                category: items[0].category,
                subcategory: items[0].subcategory,
                rating: 4,
                isFavorited: false,
                isAddedToCart: false,
                price: 12,
                thumbnailUrl: nil
            )
        ]
        
        #expect(vm.displayedItems.map(\.id) == ["2"])
        #expect(vm.appliedFilterState?.priceRange == 20...21)
    }
    
    @Test("Should log applyFilter with the selected values")
    func applyFilters_logsSelectedFilterEvent() {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(analyticsManager: analyticsManager)
        vm.allItems = items
        
        vm.applyFilters(FilterState(categoryId: "dining", priceRange: 10...15, minRating: 2))
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")
            
            return
        }
        
        #expect(name == AnalyticsEventName.applyFilter.rawValue)
        #expect(parameters[AnalyticsParamName.filterCategory.rawValue] as? String == "dining")
        #expect(parameters[AnalyticsParamName.filterRating.rawValue] as? Double == 2)
        #expect(parameters[AnalyticsParamName.filterMinPrice.rawValue] as? Double == 10)
        #expect(parameters[AnalyticsParamName.filterMaxPrice.rawValue] as? Double == 15)
    }
    
    @Test("Should log the price bounds when no price filter is selected")
    func applyFilters_logsPriceBoundsWhenPriceUnset() {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(analyticsManager: analyticsManager)
        vm.allItems = items
        
        vm.applyFilters(FilterState(minRating: 3))
        
        guard let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to have parameters")
            
            return
        }
        
        #expect(parameters[AnalyticsParamName.filterCategory.rawValue] as? String == "")
        #expect(parameters[AnalyticsParamName.filterRating.rawValue] as? Double == 3)
        #expect(parameters[AnalyticsParamName.filterMinPrice.rawValue] as? Double == 10)
        #expect(parameters[AnalyticsParamName.filterMaxPrice.rawValue] as? Double == 21)
    }
}
