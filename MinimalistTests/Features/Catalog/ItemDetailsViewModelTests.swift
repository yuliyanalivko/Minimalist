import Testing
import Foundation
@testable import Minimalist

struct ItemDetailsViewModelTests {

    let item: ItemDetails =
        ItemDetails(
            id: "1",
            name: "Vindkast",
            category: Category(
                id: "2",
                name: "Tables",
                thumbnailUrl: nil,
                subCategories: []
            ),
            subCategory: nil,
            description: "Description",
            rating: 2.5,
            isFavorited: false,
            isAddedToCart: false,
            price: 10.50,
            thumbnails: ["https://example.com/id/1041/5184/2916"],
            reviews: []
        )

    private func makeViewModel(
        mockData: Data? = mockItemDetails.data(using: .utf8),
        mockError: Error? = nil,
        favoritesMock: MockNetworkClient = MockNetworkClient(mockData: Data()),
        cartMock: MockNetworkClient = MockNetworkClient(mockData: Data()),
        analyticsManager: AnalyticsManager? = nil
    ) -> ItemDetailsViewModel {
        let catalogMock = MockNetworkClient(mockData: mockData, mockError: mockError)
        let catalogDataCoordinator = CatalogDataCoordinator(
            networkService: CatalogNetworkService(networkClient: catalogMock),
        )
        
        let favoritesDataCoordinator = FavoritesDataCoordinator(
            networkService: FavoritesNetworkService(networkClient: cartMock)
        )
        
        let cartDataCoordinator = CartDataCoordinator(
            networkService: CartNetworkService(networkClient: favoritesMock)
        )

        if let analyticsManager {
            return ItemDetailsViewModel(
                id: "1",
                catalogDataCoordinator: catalogDataCoordinator,
                favoritesDataCoordinator: favoritesDataCoordinator,
                cartDataCoordinator: cartDataCoordinator,
                analyticsManager: analyticsManager
            )
        }

        return ItemDetailsViewModel(
            id: "1",
            catalogDataCoordinator: catalogDataCoordinator,
            favoritesDataCoordinator: favoritesDataCoordinator,
            cartDataCoordinator: cartDataCoordinator
        )
    }

    @Test("Should set isFavorite to true")
    @MainActor
    func toggleFavorite_setToTrue() async {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(analyticsManager: analyticsManager)
        vm.itemDetails = item

        await vm.toggleFavorite()

        #expect(vm.itemDetails?.isFavorited == true)

        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")

            return
        }

        #expect(name == AnalyticsEventName.addToWishlist.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == item.id)
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == item.name)
    }

    @Test("Should set isFavorite to false")
    @MainActor
    func toggleFavorite_setToFalse() async {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(analyticsManager: analyticsManager)
        var favoritedItem = item
        favoritedItem.isFavorited = true
        vm.itemDetails = favoritedItem

        await vm.toggleFavorite()

        #expect(vm.itemDetails?.isFavorited == false)

        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")

            return
        }

        #expect(name == AnalyticsEventName.removeFromWishlist.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == item.id)
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == item.name)
    }

    @Test("Should set isAddedToCart to true")
    @MainActor
    func toggleCart_setToTrue() async {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(analyticsManager: analyticsManager)
        vm.itemDetails = item

        await vm.toggleCart()

        #expect(vm.itemDetails?.isAddedToCart == true)

        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")

            return
        }

        #expect(name == AnalyticsEventName.addToCart.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == item.id)
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == item.name)
    }

    @Test("Should set isAddedToCart to false")
    @MainActor
    func toggleCart_setToFalse() async {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(analyticsManager: analyticsManager)
        var cartItem = item
        cartItem.isAddedToCart = true
        vm.itemDetails = cartItem

        await vm.toggleCart()

        #expect(vm.itemDetails?.isAddedToCart == false)

        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")

            return
        }

        #expect(name == AnalyticsEventName.removeFromCart.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == item.id)
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == item.name)
    }

    @Test("Should load item details from service")
    @MainActor
    func fetchItemDetails_setItemDetails_onSuccess() async {
        let json = mockItemDetails.data(using: .utf8)!
        let expected = try! JSONDecoder().decode(ItemDetails.self, from: json)
        let vm = makeViewModel(mockData: json)

        await vm.fetchItemDetails()

        #expect(vm.itemDetails == expected)
        #expect(vm.isLoading == false)
        #expect(vm.state == ContentState.content(expected))
    }

    @Test("Should set error on failure")
    @MainActor
    func fetchItemDetails_setError_onFailure() async {
        let vm = makeViewModel(mockError: URLError(.badServerResponse))

        await vm.fetchItemDetails()

        #expect(vm.error != nil)
        #expect(vm.errorMessage == "The server returned an unexpected response. Please try again later.")
        #expect(vm.isLoading == false)
    }

    @Test("Should be loading while fetch has not completed")
    @MainActor
    func state_loading_isLoadingTrue() {
        let vm = makeViewModel()
        vm.isLoading = true

        #expect(vm.state == .loading)
    }

    @Test("Should be empty when itemDetails is nil")
    @MainActor
    func state_empty_itemDetailsIsNil() {
        let vm = makeViewModel()
        vm.isLoading = false

        #expect(vm.state == .empty)
    }
}
