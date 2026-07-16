import Foundation
import Testing
@testable import Minimalist

struct CatalogDataCoordinatorTests {

    private func makeCoordinator(
        catalogMock: MockNetworkClient,
        favoritesMock: MockNetworkClient = MockNetworkClient(mockData: Data()),
        cartMock: MockNetworkClient = MockNetworkClient(mockData: Data())
    ) -> CatalogDataCoordinator {
        CatalogDataCoordinator(
            networkService: CatalogNetworkService(networkClient: catalogMock),
            favoritesNetworkService: FavoritesNetworkService(networkClient: favoritesMock),
            cartNetworkService: CartNetworkService(networkClient: cartMock)
        )
    }

    @Test("Should return decoded categories")
    func getCategories_returnCategories() async throws {
        let json = mockCategories.data(using: .utf8)!
        let coordinator = makeCoordinator(catalogMock: MockNetworkClient(mockData: json))

        let categories = try await coordinator.getCategories()

        #expect(categories.count == 1)
        #expect(categories.first?.id == "1")
        #expect(categories.first?.name == "Sofas")
    }

    @Test("Should return decoded items")
    func getItems_returnItems() async throws {
        let json = mockItems.data(using: .utf8)!
        let coordinator = makeCoordinator(catalogMock: MockNetworkClient(mockData: json))

        let items = try await coordinator.getItems(categoryId: "1")

        #expect(items.count == 1)
        #expect(items.first?.id == "1")
        #expect(items.first?.name == "Vindkast")
    }

    @Test("Should return decoded item details")
    func getItemDetails_returnItemDetails() async throws {
        let json = mockItemDetails.data(using: .utf8)!
        let coordinator = makeCoordinator(catalogMock: MockNetworkClient(mockData: json))

        let details = try await coordinator.getItemDetails(id: "1")

        #expect(details.id == "1")
        #expect(details.name == "Vindkast")
    }

    @Test("Should add item to favorites")
    func addToFavorites_succeeds() async throws {
        let favoritesMock = MockNetworkClient(mockData: Data())
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: Data()),
            favoritesMock: favoritesMock
        )

        try await coordinator.addToFavorites(id: "item-1")

        #expect(favoritesMock.lastRequest?.httpMethod == "POST")
        #expect(favoritesMock.lastRequest?.url?.path == "/api/v1/favorites")
    }

    @Test("Should remove item from favorites")
    func removeFromFavorites_succeeds() async throws {
        let favoritesMock = MockNetworkClient(mockData: Data())
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: Data()),
            favoritesMock: favoritesMock
        )

        try await coordinator.removeFromFavorites(id: "item-1")

        #expect(favoritesMock.lastRequest?.httpMethod == "DELETE")
        #expect(favoritesMock.lastRequest?.url?.query?.contains("id=item-1") == true)
    }

    @Test("Should add item to cart")
    func addToCart_succeeds() async throws {
        let cartMock = MockNetworkClient(mockData: Data())
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: Data()),
            cartMock: cartMock
        )

        try await coordinator.addToCart(id: "item-1")

        #expect(cartMock.lastRequest?.httpMethod == "POST")
        #expect(cartMock.lastRequest?.url?.path == "/api/v1/cart")
    }

    @Test("Should remove item from cart")
    func removeFromCart_succeeds() async throws {
        let cartMock = MockNetworkClient(mockData: Data())
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: Data()),
            cartMock: cartMock
        )

        try await coordinator.removeFromCart(id: "item-1")

        #expect(cartMock.lastRequest?.httpMethod == "DELETE")
        #expect(cartMock.lastRequest?.url?.query?.contains("id=item-1") == true)
    }

    @Test("Should throw network error for server failure")
    func getCategories_throwNetworkError() async {
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: nil, mockError: URLError(.badServerResponse))
        )

        do {
            _ = try await coordinator.getCategories()
            Issue.record("Expected error")
        } catch let error as MinimalistError {
            guard case .networkError = error else {
                Issue.record("Expected networkError, got \(error)")
                return
            }

            #expect(error.localizedDescription == "The server returned an unexpected response. Please try again later.")
        } catch {
            Issue.record("Expected MinimalistError, got \(error)")
        }
    }
}
