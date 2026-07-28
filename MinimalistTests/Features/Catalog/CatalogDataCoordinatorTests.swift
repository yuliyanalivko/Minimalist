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
    
    private func collectData<T>(
        from stream: AsyncThrowingStream<T, Error>
    ) async throws -> [T] {
        var data: [T] = []
        
        for try await value in stream {
            data.append(value)
        }
        
        return data
    }
    
    // MARK: getCategories()
    
    @Test("Should emit only network categories when cache is empty")
    func getCategories_emptyCache_emitsNetworkOnly() async throws {
        let json = mockCategories.data(using: .utf8)!
        let expected = try JSONDecoder().decode(
            [Minimalist.Category].self,
            from: json
        )
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: json)
        )
        
        let emissions = try await collectData(
            from: coordinator.getCategories()
        )
        
        #expect(emissions.count == 1)
        #expect(emissions[0] == expected)
    }
    
    @Test("Should emit cache then network when cache exists")
    func getCategories_cacheThenNetwork_emitsTwice() async throws {
        let cached = [
            Category(
                id: "c1",
                name: "Cached",
                thumbnailUrl: nil,
                subCategories: []
            )
        ]
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toEntity() }
        let json = mockCategories.data(using: .utf8)!
        let network = try JSONDecoder().decode(
            [Minimalist.Category].self,
            from: json
        )
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: json),
            database: database
        )
        
        let emissions = try await collectData(
            from: coordinator.getCategories()
        )
        
        #expect(emissions.count == 2)
        #expect(emissions[0] == cached)
        #expect(emissions[1] == network)
    }
    
    @Test("Should save network categories to database on success")
    func getCategories_networkSuccess_savesToDatabase() async throws {
        let json = mockCategories.data(using: .utf8)!
        let expected = try JSONDecoder().decode(
            [Minimalist.Category].self,
            from: json
        )
        let database = MockDatabaseManager()
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: json),
            database: database
        )
        _ = try await collectData(from: coordinator.getCategories())
        
        let saved = try database.get(type: CategoryEntity.self).map(
            Category.init(from:)
        )
        
        #expect(saved == expected)
    }
    
    @Test("Should emit cache then throw when network fails")
    func getCategories_networkFailure_withCache_emitsThenThrows() async throws {
        let cached = [Category(
            id: "1",
            name: "Sofas",
            thumbnailUrl: nil,
            subCategories: []
        )]
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toEntity() }
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(
                mockData: nil,
                mockError: URLError(.badServerResponse)
            ),
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
            catalogMock: MockNetworkClient(
                mockData: nil,
                mockError: URLError(.badServerResponse)
            )
        )
        
        do {
            _ = try await collectData(from: coordinator.getCategories())
            Issue.record("Expected error")
        } catch let error as MinimalistError {
            guard case .networkError = error else {
                Issue.record("Expected networkError, got \(error)")
                return
            }
            #expect(
                error.localizedDescription == "The server returned an unexpected response. Please try again later."
            )
        } catch {
            Issue.record("Expected MinimalistError, got \(error)")
        }
    }
    
    // MARK: getItems()
    
    @Test("Should emit only network items when cache is empty")
    func getItems_emptyCache_emitsNetworkOnly() async throws {
        let json = mockItems.data(using: .utf8)!
        let expected = try JSONDecoder().decode([Item].self, from: json)
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: json)
        )
        
        let emissions = try await collectData(
            from: coordinator.getItems(categoryId: "1")
        )
        
        #expect(emissions.count == 1)
        #expect(emissions[0] == expected)
    }
    
    @Test("Should emit cache then network when cache exists")
    func getItems_cacheThenNetwork_emitsTwice() async throws {
        let cached = [
            Item(
                id: "1",
                name: "Sofa",
                category: nil,
                subcategory: nil,
                rating: 2.5,
                isFavorited: false,
                isAddedToCart: false,
                price: 99.99
            )
        ]
        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toEntity() }
        let json = mockItems.data(using: .utf8)!
        let network = try JSONDecoder().decode([Item].self, from: json)
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: json),
            database: database
        )
        
        let emissions = try await collectData(
            from: coordinator.getItems(categoryId: "1")
        )
        
        #expect(emissions.count == 2)
        #expect(emissions[0] == cached)
        #expect(emissions[1] == network)
    }
    
    @Test("Should save network items to database on success")
    func getItems_networkSuccess_savesToDatabase() async throws {
        let json = mockItems.data(using: .utf8)!
        let expected = try JSONDecoder().decode([Item].self, from: json)
        let database = MockDatabaseManager()
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: json),
            database: database
        )
        _ = try await collectData(from: coordinator.getItems(categoryId: "1"))
        
        let saved = try database.get(type: ItemEntity.self).map(
            Item.init(from:)
        )
        
        #expect(saved == expected)
    }
    
    @Test("Should emit cache then throw when network fails")
    func getItems_networkFailure_withCache_emitsThenThrows() async throws {
        let cached = [
            Item(
                id: "1",
                name: "Sofa",
                category: nil,
                subcategory: nil,
                rating: 2.5,
                isFavorited: false,
                isAddedToCart: false,
                price: 99.99
            )
        ]

        let database = MockDatabaseManager()
        database.objects = cached.map { $0.toEntity() }
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(
                mockData: nil,
                mockError: URLError(.badServerResponse)
            ),
            database: database
        )
        var items: [[Item]] = []
        var thrown: Error?
        
        do {
            for try await value in coordinator.getItems(categoryId: "1") {
                items.append(value)
            }
        } catch {
            thrown = error
        }
        
        #expect(items == [cached])
        #expect(thrown is MinimalistError)
    }
    
    @Test("Should throw network error when cache is empty")
    func getItems_networkFailure_emptyCache_throws() async {
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(
                mockData: nil,
                mockError: URLError(.badServerResponse)
            )
        )
        
        do {
            _ = try await collectData(
                from: coordinator.getItems(categoryId: "1")
            )
            Issue.record("Expected error")
        } catch let error as MinimalistError {
            guard case .networkError = error else {
                Issue.record("Expected networkError, got \(error)")
                return
            }
            #expect(
                error.localizedDescription == "The server returned an unexpected response. Please try again later."
            )
        } catch {
            Issue.record("Expected MinimalistError, got \(error)")
        }
    }
    
    // MARK: getItemDetails()
    
    @Test("Should emit only network item details when cache is empty")
    func getItemDetails_emptyCache_emitsNetworkOnly() async throws {
        let json = mockItemDetails.data(using: .utf8)!
        let expected = try JSONDecoder().decode(ItemDetails.self, from: json)
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: json)
        )
        
        let emissions = try await collectData(
            from: coordinator.getItemDetails(id: "1")
        )
        
        #expect(emissions.count == 1)
        #expect(emissions[0] == expected)
    }
    
    @Test("Should emit cache then network when cache exists")
    func getItemDetails_cacheThenNetwork_emitsTwice() async throws {
        let cached = ItemDetails(
            id: "1",
            name: "Sofa",
            category: nil,
            subCategory: nil,
            description: "",
            rating: 2.5,
            isFavorited: false,
            isAddedToCart: false,
            price: 99.99,
            thumbnails: [],
            reviews: []
        )
        
        let database = MockDatabaseManager()
        database.objects = [cached.toEntity()]
        let json = mockItemDetails.data(using: .utf8)!
        let network = try JSONDecoder().decode(ItemDetails.self, from: json)
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: json),
            database: database
        )
        
        let emissions = try await collectData(
            from: coordinator.getItemDetails(id: "1")
        )
        
        #expect(emissions.count == 2)
        #expect(emissions[0] == cached)
        #expect(emissions[1] == network)
    }
    
    @Test("Should save network item details to database on success")
    func getItemDetails_networkSuccess_savesToDatabase() async throws {
        let json = mockItemDetails.data(using: .utf8)!
        let expected = try JSONDecoder().decode(ItemDetails.self, from: json)
        let database = MockDatabaseManager()
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(mockData: json),
            database: database
        )
        _ = try await collectData(from: coordinator.getItemDetails(id: "1"))
        
        let saved = try database.get(type: ItemDetailsEntity.self).map(
            ItemDetails.init(from:)
        )
        
        #expect(saved.first == expected)
    }
    
    @Test("Should emit cache then throw when network fails")
    func getItemDetails_networkFailure_withCache_emitsThenThrows() async throws {
        let cached = ItemDetails(
            id: "1",
            name: "Sofa",
            category: nil,
            subCategory: nil,
            description: "",
            rating: 2.5,
            isFavorited: false,
            isAddedToCart: false,
            price: 99.99,
            thumbnails: [],
            reviews: []
        )

        let database = MockDatabaseManager()
        database.objects = [cached.toEntity()]
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(
                mockData: nil,
                mockError: URLError(.badServerResponse)
            ),
            database: database
        )
        var itemDetails: ItemDetails?
        var thrown: Error?
        
        do {
            for try await value in coordinator.getItemDetails(id: "1") {
                itemDetails = value
            }
        } catch {
            thrown = error
        }
        
        #expect(itemDetails == cached)
        #expect(thrown is MinimalistError)
    }
    
    @Test("Should throw network error when cache is empty")
    func getItemDetails_networkFailure_emptyCache_throws() async {
        let coordinator = makeCoordinator(
            catalogMock: MockNetworkClient(
                mockData: nil,
                mockError: URLError(.badServerResponse)
            )
        )
        
        do {
            _ = try await collectData(
                from: coordinator.getItemDetails(id: "1")
            )
            Issue.record("Expected error")
        } catch let error as MinimalistError {
            guard case .networkError = error else {
                Issue.record("Expected networkError, got \(error)")
                return
            }
            #expect(
                error.localizedDescription == "The server returned an unexpected response. Please try again later."
            )
        } catch {
            Issue.record("Expected MinimalistError, got \(error)")
        }
    }
}
