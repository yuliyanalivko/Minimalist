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
