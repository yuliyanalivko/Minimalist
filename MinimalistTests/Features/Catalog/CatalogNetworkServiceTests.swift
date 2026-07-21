import Foundation
import Testing
@testable import Minimalist

struct CatalogNetworkServiceTests {

    private func makeService(mockData: Data?, mockError: Error? = nil) -> (CatalogNetworkService, MockNetworkClient) {
        let mockClient = MockNetworkClient(mockData: mockData, mockError: mockError)
        let service = CatalogNetworkService(networkClient: mockClient)
        service.host = "https://example.com"
        return (service, mockClient)
    }

    @Test("Should return categories on success")
    func getCategories_onSuccess_returnData() async throws {
        let json = mockCategories.data(using: .utf8)!
        let (service, _) = makeService(mockData: json)

        let categories = try JSONDecoder().decode([Minimalist.Category].self, from: try await service.getCategories())

        #expect(categories.count == 1)
        #expect(categories.first?.name == "Sofas")
    }

    @Test("Should call api/v1/categories endpoint")
    func getCategories_useCorrectEndpoint() async throws {
        let json = mockCategories.data(using: .utf8)!
        let (service, mockClient) = makeService(mockData: json)

        _ = try await service.getCategories()

        #expect(mockClient.lastRequest?.httpMethod == "GET")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/categories")
    }

    @Test("Should call api/v1/search with category query")
    func getItems_useCorrectEndpoint() async throws {
        let json = mockItems.data(using: .utf8)!
        let (service, mockClient) = makeService(mockData: json)

        _ = try await service.getItems(categoryId: "cat-1")

        #expect(mockClient.lastRequest?.httpMethod == "GET")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/search")
        #expect(mockClient.lastRequest?.url?.query?.contains("categories=cat-1") == true)
    }

    @Test("Should call api/v1/item/details with id query and User-ID header")
    func getItemDetails_useCorrectEndpoint() async throws {
        let json = mockItemDetails.data(using: .utf8)!
        let (service, mockClient) = makeService(mockData: json)

        _ = try await service.getItemDetails(id: "item-1")

        #expect(mockClient.lastRequest?.httpMethod == "GET")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/item/details")
        #expect(mockClient.lastRequest?.url?.query?.contains("id=item-1") == true)
        #expect(mockClient.lastRequest?.value(forHTTPHeaderField: "User-ID") == "9b7135f6-c435-4b37-8456-bcb9c812b128")
    }

    @Test("Should forward the network error when the client fails")
    func getCategories_onFailure_throwForwardedError() async {
        let expectedError = URLError(.notConnectedToInternet)
        let (service, _) = makeService(mockData: nil, mockError: expectedError)

        await #expect(throws: URLError.self) {
            try await service.getCategories()
        }
    }
}
