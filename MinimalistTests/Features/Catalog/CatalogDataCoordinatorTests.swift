import Foundation
import Testing
@testable import Minimalist

struct CatalogDataCoordinatorTests {

    @Test("Should return decoded categories")
    func getCategories_returnCategories() async throws {
        let json = mockCategories.data(using: .utf8)!
        let mockClient = MockNetworkClient(mockData: json)
        let coordinator = CatalogDataCoordinator(
            networkService: CatalogNetworkService(networkClient: mockClient)
        )

        let categories = try await coordinator.getCategories()

        #expect(categories.count == 1)
        #expect(categories.first?.id == "1")
        #expect(categories.first?.name == "Sofas")
    }

    @Test("Should throw network error for server failure")
    func getCategories_throwNetworkError() async {
        let mockClient = MockNetworkClient(mockData: nil, mockError: URLError(.badServerResponse))
        let coordinator = CatalogDataCoordinator(
            networkService: CatalogNetworkService(networkClient: mockClient)
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
