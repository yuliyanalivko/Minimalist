import Foundation
import Testing
@testable import Minimalist

struct FavoritesDataCoordinatorTests {

    private func makeCoordinator(
        mockData: Data?,
        mockError: Error? = nil,
        database: MockDatabaseManager = MockDatabaseManager()
    ) -> (FavoritesDataCoordinator, MockNetworkClient, MockDatabaseManager) {
        let mockClient = MockNetworkClient(mockData: mockData, mockError: mockError)
        let coordinator = FavoritesDataCoordinator(
            networkService: FavoritesNetworkService(networkClient: mockClient),
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
    
    private func favoritedItem() -> Item {
        var cached = item
        cached.isFavorited = true
        
        return cached
    }

    @Test("Should emit only network favorites when cache is empty")
    func getFavorites_emptyCache_emitsNetworkOnly() async throws {
        let json = mockItems.data(using: .utf8)!
        let expected = try JSONDecoder().decode([Item].self, from: json)
        let (coordinator, _, _) = makeCoordinator(mockData: json)

        let emissions = try await collectData(from: coordinator.getFavorites())

        #expect(emissions.count == 1)
        #expect(emissions[0] == expected)
    }
    
    @Test("Should emit cache then network when favorites exist in cache")
    func getFavorites_cacheThenNetwork_emitsTwice() async throws {
        let cached = [favoritedItem()]
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toRealm() }
        let json = mockItems.data(using: .utf8)!
        let network = try JSONDecoder().decode([Item].self, from: json)
        let (coordinator, _, _) = makeCoordinator(mockData: json, database: database)
        
        let emissions = try await collectData(from: coordinator.getFavorites())
        
        #expect(emissions.count == 2)
        #expect(emissions[0] == cached)
        #expect(emissions[1] == network)
    }
    
    @Test("Should ignore cached items that are not favorited")
    func getFavorites_cache_skipsNonFavoritedItems() async throws {
        let database = MockDatabaseManager()
        database.objects = [item.toRealm()]
        let json = mockItems.data(using: .utf8)!
        let network = try JSONDecoder().decode([Item].self, from: json)
        let (coordinator, _, _) = makeCoordinator(mockData: json, database: database)
        
        let emissions = try await collectData(from: coordinator.getFavorites())
        
        #expect(emissions.count == 1)
        #expect(emissions[0] == network)
    }
    
    @Test("Should save network favorites to database on success")
    func getFavorites_networkSuccess_savesToDatabase() async throws {
        let json = mockItems.data(using: .utf8)!
        let expected = try JSONDecoder().decode([Item].self, from: json)
        let database = MockDatabaseManager()
        let (coordinator, _, _) = makeCoordinator(mockData: json, database: database)
        
        _ = try await collectData(from: coordinator.getFavorites())
        
        let saved = try database.get(type: RealmItem.self).map(Item.init(from:))
        
        #expect(saved == expected)
    }

    @Test("Should add item to favorites and update the store")
    func addToFavorites_succeeds() async throws {
        let database = MockDatabaseManager()
        database.objects = [item.toRealm()]
        let (coordinator, mockClient, _) = makeCoordinator(mockData: Data(), database: database)

        try await coordinator.addToFavorites(id: "1")

        #expect(mockClient.lastRequest?.httpMethod == "POST")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/favorites")
        #expect(try database.get(type: RealmItem.self, id: "1")?.isFavorited == true)
    }

    @Test("Should remove item from favorites and update the store")
    func removeFromFavorites_succeeds() async throws {
        let database = MockDatabaseManager()
        database.objects = [favoritedItem().toRealm()]
        let (coordinator, mockClient, _) = makeCoordinator(mockData: Data(), database: database)

        try await coordinator.removeFromFavorites(id: "1")

        #expect(mockClient.lastRequest?.httpMethod == "DELETE")
        #expect(mockClient.lastRequest?.url?.query?.contains("id=1") == true)
        #expect(try database.get(type: RealmItem.self, id: "1")?.isFavorited == false)
    }
    
    @Test("Should emit cache then throw when network fails")
    func getFavorites_networkFailure_withCache_emitsThenThrows() async throws {
        let cached = [favoritedItem()]
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
            for try await value in coordinator.getFavorites() {
                items.append(value)
            }
        } catch {
            thrown = error
        }
        
        #expect(items == [cached])
        #expect(thrown is MinimalistError)
    }

    @Test("Should throw network error when cache is empty")
    func getFavorites_throwNetworkError() async {
        let (coordinator, _, _) = makeCoordinator(mockData: nil, mockError: URLError(.badServerResponse))

        do {
            _ = try await collectData(from: coordinator.getFavorites())
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
