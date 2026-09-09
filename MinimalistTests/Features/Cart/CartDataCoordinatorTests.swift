import Foundation
import Testing
@testable import Minimalist

struct CartDataCoordinatorTests {

    private func makeCoordinator(
        mockData: Data?,
        mockError: Error? = nil,
        database: MockDatabaseManager = MockDatabaseManager()
    ) -> (CartDataCoordinator, MockNetworkClient, MockDatabaseManager) {
        let mockClient = MockNetworkClient(mockData: mockData, mockError: mockError)
        let coordinator = CartDataCoordinator(
            networkService: CartNetworkService(networkClient: mockClient),
            storeResolver: { RealmStore(databaseManager: database) }
        )
        
        return (coordinator, mockClient, database)
    }

    @Test("Should return decoded cart items")
    func getCartItems_returnItems() async throws {
        let json = mockItems.data(using: .utf8)!
        let (coordinator, _, _) = makeCoordinator(mockData: json)

        let items = try await coordinator.getCartItems()

        #expect(items.count == 1)
        #expect(items.first?.id == "1")
        #expect(items.first?.name == "Vindkast")
    }

    @Test("Should add item to cart and update the store")
    func addToCart_succeeds() async throws {
        let database = MockDatabaseManager()
        database.objects = [item.toRealm(), itemDetails.toRealm()]
        let (coordinator, mockClient, _) = makeCoordinator(mockData: Data(), database: database)

        try await coordinator.addToCart(id: "1")

        #expect(mockClient.lastRequest?.httpMethod == "POST")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/cart")
        #expect(try database.get(type: RealmItem.self, id: "1")?.isAddedToCart == true)
        #expect(try database.get(type: RealmItemDetails.self, id: "1")?.isAddedToCart == true)
    }

    @Test("Should remove item from cart and update the store")
    func removeFromCart_succeeds() async throws {
        var cached = item
        cached.isAddedToCart = true
        var cachedDetails = itemDetails
        cachedDetails.isAddedToCart = true
        
        let database = MockDatabaseManager()
        database.objects = [cached.toRealm(), cachedDetails.toRealm()]
        let (coordinator, mockClient, _) = makeCoordinator(mockData: Data(), database: database)

        try await coordinator.removeFromCart(id: "1")

        #expect(mockClient.lastRequest?.httpMethod == "DELETE")
        #expect(mockClient.lastRequest?.url?.query?.contains("id=1") == true)
        #expect(try database.get(type: RealmItem.self, id: "1")?.isAddedToCart == false)
        #expect(try database.get(type: RealmItemDetails.self, id: "1")?.isAddedToCart == false)
    }

    @Test("Should throw network error for server failure")
    func getCartItems_throwNetworkError() async {
        let (coordinator, _, _) = makeCoordinator(mockData: nil, mockError: URLError(.badServerResponse))

        do {
            _ = try await coordinator.getCartItems()
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
