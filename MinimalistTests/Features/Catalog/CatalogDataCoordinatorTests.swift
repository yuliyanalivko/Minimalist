import Foundation
import Testing
@testable import Minimalist

struct CatalogDataCoordinatorTests {
    
    private func makeCoordinator(
        catalogMock: MockNetworkClient,
        database: MockDatabaseManager = MockDatabaseManager()
    ) -> CatalogDataCoordinator {
        CatalogDataCoordinator(
            networkService: CatalogNetworkService(networkClient: catalogMock),
            databaseManager: database
        )
    }
    
    private func collectCategories(
        from stream: AsyncThrowingStream<[Minimalist.Category], Error>
    ) async throws -> [[Minimalist.Category]] {
        var categories: [[Minimalist.Category]] = []
        
        for try await value in stream {
            categories.append(value)
        }
        
        return categories
    }
    
    @Test("Should emit only network categories when cache is empty")
    func getCategories_emptyCache_emitsNetworkOnly() async throws {
        let json = mockCategories.data(using: .utf8)!
        let expected = try JSONDecoder().decode([Minimalist.Category].self, from: json)
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: json)
        )
        
        let emissions = try await collectCategories(from: coordinator.getCategories())
        
        #expect(emissions.count == 1)
        #expect(emissions[0] == expected)
    }
    
    @Test("Should emit cache then network when cache exists")
    func getCategories_cacheThenNetwork_emitsTwice() async throws {
        let cached = [
            Category(id: "c1", name: "Cached", thumbnailUrl: nil, subCategories: [])
        ]
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toEntity() }
        let json = mockCategories.data(using: .utf8)!
        let network = try JSONDecoder().decode([Minimalist.Category].self, from: json)
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: json),
            database: database
        )
        
        let emissions = try await collectCategories(from: coordinator.getCategories())
        
        #expect(emissions.count == 2)
        #expect(emissions[0] == cached)
        #expect(emissions[1] == network)
    }
    
    @Test("Should save network categories to database on success")
    func getCategories_networkSuccess_savesToDatabase() async throws {
        let json = mockCategories.data(using: .utf8)!
        let expected = try JSONDecoder().decode([Minimalist.Category].self, from: json)
        let database = MockDatabaseManager()
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: json),
            database: database
        )
        _ = try await collectCategories(from: coordinator.getCategories())
        
        let saved = try database.get(type: CategoryEntity.self).map(Category.init(from:))
        
        #expect(saved == expected)
    }
    
    @Test("Should emit cache then throw when network fails")
    func getCategories_networkFailure_withCache_emitsThenThrows() async throws {
        let cached = [Category(id: "1", name: "Sofas", thumbnailUrl: nil, subCategories: [])]
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toEntity() }
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: nil, mockError: URLError(.badServerResponse)),
            database: database
        )
        var categories: [[Minimalist.Category]] = []
        var thrown: Error?
        
        do {
            for try await value in coordinator.getCategories() {
                categories.append(value)
            }
        } catch {
            thrown = error
        }
        
        #expect(categories == [cached])
        #expect(thrown is MinimalistError)
    }
    
    @Test("Should throw network error when cache is empty")
    func getCategories_networkFailure_emptyCache_throws() async {
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: nil, mockError: URLError(.badServerResponse))
        )
        
        do {
            _ = try await collectCategories(from: coordinator.getCategories())
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
}
