import Foundation
import Testing
@testable import Minimalist

@MainActor
struct CartServiceTests {

    private func makeService(
        mockData: Data?,
        mockError: Error? = nil,
        database: MockDatabaseManager = MockDatabaseManager()
    ) -> (CartService, MockNetworkClient, MockDatabaseManager) {
        let mockClient = MockNetworkClient(mockData: mockData, mockError: mockError)
        let coordinator = CartDataCoordinator(
            networkService: CartNetworkService(networkClient: mockClient),
            storeResolver: { RealmStore(databaseManager: database) }
        )
        let service = CartService(dataCoordinator: coordinator)

        return (service, mockClient, database)
    }

    private func collectData<T>(
        from stream: AsyncThrowingStream<T, Error>
    ) async throws -> [T] {
        var data: [T] = []

        for try await value in stream {
            data.append(value)
        }

        return data
    }

    private func cartItem() -> Item {
        var cached = item
        cached.isAddedToCart = true

        return cached
    }

    private func twoItemsJSON() -> Data {
        """
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
            "thumbnailUrl": null
          },
          {
            "id": "2",
            "name": "Solklint",
            "category": null,
            "subcategory": null,
            "rating": 5.5,
            "isFavorited": false,
            "isAddedToCart": true,
            "price": 20.50,
            "thumbnailUrl": null
          }
        ]
        """.data(using: .utf8)!
    }

    @Test("Should emit network cart items and update local items when cache is empty")
    func getCartItems_emptyCache_emitNetworkAndUpdatesItems() async throws {
        let json = mockItems.data(using: .utf8)!
        let expected = try JSONDecoder().decode([Item].self, from: json)
        let (service, _, _) = makeService(mockData: json)

        let emissions = try await collectData(from: service.getCartItems())

        #expect(emissions.count == 1)
        #expect(emissions[0] == expected)
        #expect(service.items == expected)
        #expect(service.itemCount == expected.count)
    }

    @Test("Should emit cache then network and keep the latest items")
    func getCartItems_cacheThenNetwork_updateItemsToNetwork() async throws {
        let cached = [cartItem()]
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toRealm() }
        let json = mockItems.data(using: .utf8)!
        let network = try JSONDecoder().decode([Item].self, from: json)
        let (service, _, _) = makeService(mockData: json, database: database)

        let emissions = try await collectData(from: service.getCartItems())

        #expect(emissions.count == 2)
        #expect(emissions[0] == cached)
        #expect(emissions[1] == network)
        #expect(service.items == network)
        #expect(service.itemCount == network.count)
    }

    @Test("Should throw network error when cache is empty")
    func getCartItems_throwNetworkError() async {
        let (service, _, _) = makeService(mockData: nil, mockError: URLError(.badServerResponse))

        do {
            _ = try await collectData(from: service.getCartItems())
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

        #expect(service.items.isEmpty)
        #expect(service.itemCount == 0)
    }

    @Test("Should emit cache then throw when network fails")
    func getCartItems_networkFailure_withCache_emitThenThrows() async throws {
        let cached = [cartItem()]
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toRealm() }
        let (service, _, _) = makeService(
            mockData: nil,
            mockError: URLError(.badServerResponse),
            database: database
        )
        var items: [[Item]] = []
        var thrown: Error?

        do {
            for try await value in service.getCartItems() {
                items.append(value)
            }
        } catch {
            thrown = error
        }

        #expect(items == [cached])
        #expect(thrown is MinimalistError)
        #expect(service.items == cached)
        #expect(service.itemCount == cached.count)
    }

    @Test("Should load cart items into local state on success")
    func loadCartItems_networkSuccess_updateItems() async throws {
        let json = mockItems.data(using: .utf8)!
        let expected = try JSONDecoder().decode([Item].self, from: json)
        let (service, _, _) = makeService(mockData: json)

        await service.loadCartItems()

        #expect(service.items == expected)
        #expect(service.itemCount == expected.count)
    }

    @Test("Should ignore errors when loading cart items fails")
    func loadCartItems_networkFailure_doNotThrow() async {
        let (service, _, _) = makeService(mockData: nil, mockError: URLError(.badServerResponse))

        await service.loadCartItems()

        #expect(service.items.isEmpty)
        #expect(service.itemCount == 0)
    }

    @Test("Should keep cached cart items when loading fails after cache")
    func loadCartItems_networkFailure_keepCache() async {
        let cached = [cartItem()]
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toRealm() }
        let (service, _, _) = makeService(
            mockData: nil,
            mockError: URLError(.badServerResponse),
            database: database
        )

        await service.loadCartItems()

        #expect(service.items == cached)
        #expect(service.itemCount == cached.count)
    }

    @Test("Should reload cart items after adding to cart")
    func addToCart_reloadItems() async throws {
        let json = mockItems.data(using: .utf8)!
        let expected = try JSONDecoder().decode([Item].self, from: json)
        let (service, mockClient, _) = makeService(mockData: json)

        try await service.addToCart(id: "1")

        #expect(service.items == expected)
        #expect(service.itemCount == expected.count)
        #expect(mockClient.lastRequest?.httpMethod == "GET")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/cart")
    }

    @Test("Should throw and keep items empty when adding to cart fails")
    func addToCart_networkFailure_doNotUpdateItems() async {
        let (service, _, _) = makeService(mockData: nil, mockError: URLError(.badServerResponse))

        do {
            try await service.addToCart(id: "1")
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

        #expect(service.items.isEmpty)
        #expect(service.itemCount == 0)
    }

    @Test("Should remove matching item from local cart on success")
    func removeFromCart_removeMatchingItem() async throws {
        let json = twoItemsJSON()
        let (service, mockClient, _) = makeService(mockData: json)

        await service.loadCartItems()

        #expect(service.itemCount == 2)

        try await service.removeFromCart(id: "1")

        #expect(service.items.map(\.id) == ["2"])
        #expect(service.itemCount == 1)
        #expect(mockClient.lastRequest?.httpMethod == "DELETE")
        #expect(mockClient.lastRequest?.url?.query?.contains("id=1") == true)
    }

    @Test("Should keep items when removing from cart fails")
    func removeFromCart_networkFailure_keepItems() async throws {
        let json = mockItems.data(using: .utf8)!
        let expected = try JSONDecoder().decode([Item].self, from: json)
        let mockClient = MockNetworkClient(mockData: json)
        let coordinator = CartDataCoordinator(
            networkService: CartNetworkService(networkClient: mockClient),
            storeResolver: { RealmStore(databaseManager: MockDatabaseManager()) }
        )
        let service = CartService(dataCoordinator: coordinator)

        await service.loadCartItems()
        mockClient.mockError = URLError(.badServerResponse)

        do {
            try await service.removeFromCart(id: "1")
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

        #expect(service.items == expected)
        #expect(service.itemCount == expected.count)
    }
}
