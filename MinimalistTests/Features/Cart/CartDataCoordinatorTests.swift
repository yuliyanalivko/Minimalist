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

    @Test("Should emit only network cart items when cache is empty")
    func getCartItems_emptyCache_emitsNetworkOnly() async throws {
        let json = mockItems.data(using: .utf8)!
        let expected = try JSONDecoder().decode([Item].self, from: json)
        let (coordinator, _, _) = makeCoordinator(mockData: json)

        let emissions = try await collectData(from: coordinator.getCartItems())

        #expect(emissions.count == 1)
        #expect(emissions[0] == expected)
    }
    
    @Test("Should emit cache then network when cart items exist in cache")
    func getCartItems_cacheThenNetwork_emitsTwice() async throws {
        let cached = [cartItem()]
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toRealm() }
        let json = mockItems.data(using: .utf8)!
        let network = try JSONDecoder().decode([Item].self, from: json)
        let (coordinator, _, _) = makeCoordinator(mockData: json, database: database)
        
        let emissions = try await collectData(from: coordinator.getCartItems())
        
        #expect(emissions.count == 2)
        #expect(emissions[0] == cached)
        #expect(emissions[1] == network)
    }
    
    @Test("Should ignore cached items that are not added to cart")
    func getCartItems_cache_skipsNonCartItems() async throws {
        let database = MockDatabaseManager()
        database.objects = [item.toRealm()]
        let json = mockItems.data(using: .utf8)!
        let network = try JSONDecoder().decode([Item].self, from: json)
        let (coordinator, _, _) = makeCoordinator(mockData: json, database: database)
        
        let emissions = try await collectData(from: coordinator.getCartItems())
        
        #expect(emissions.count == 1)
        #expect(emissions[0] == network)
    }
    
    @Test("Should save network cart items to database on success")
    func getCartItems_networkSuccess_savesToDatabase() async throws {
        let json = mockItems.data(using: .utf8)!
        let expected = try JSONDecoder().decode([Item].self, from: json)
        let database = MockDatabaseManager()
        let (coordinator, _, _) = makeCoordinator(mockData: json, database: database)
        
        _ = try await collectData(from: coordinator.getCartItems())
        
        let saved = try database.get(type: RealmItem.self).map(Item.init(from:))
        
        #expect(saved == expected)
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

    @Test("Should emit cache then throw when network fails")
    func getCartItems_networkFailure_withCache_emitsThenThrows() async throws {
        let cached = [cartItem()]
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toRealm() }
        let (coordinator, _, _) = makeCoordinator(
            mockData: nil,
            mockError: URLError(.badServerResponse),
            database: database
        )
        var items: [[Item]] = []
        var thrown: Error?
        
        do {
            for try await value in coordinator.getCartItems() {
                items.append(value)
            }
        } catch {
            thrown = error
        }
        
        #expect(items == [cached])
        #expect(thrown is MinimalistError)
    }

    @Test("Should throw network error when cache is empty")
    func getCartItems_throwNetworkError() async {
        let (coordinator, _, _) = makeCoordinator(mockData: nil, mockError: URLError(.badServerResponse))

        do {
            _ = try await collectData(from: coordinator.getCartItems())
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
