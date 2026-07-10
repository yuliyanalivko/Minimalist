import Foundation
import Testing
@testable import Minimalist

struct CatalogNetworkServiceTests {
    
    @MainActor
    @Test("Should call return categories")
    func getCategories_onSuccess_returnData() async throws {
        let json = mockCategories.data(using: .utf8)!
        let mockClient = MockNetworkClient(mockData: json)
        let service = CatalogNetworkService(networkClient: mockClient)
        
        let categories = try JSONDecoder().decode([Minimalist.Category].self, from: try await service.getCategories())
        
        #expect(categories.count == 1)
        #expect(categories.first?.name == "Sofas")
    }
    
    @MainActor
    @Test("Should forward the network error when the client fails")
    func getCategories_onFailure_throwForwardedError() async {
        let expectedError = URLError(.notConnectedToInternet)
        let mockClient = MockNetworkClient(mockData: nil, mockError: expectedError)
        let service = CatalogNetworkService(networkClient: mockClient)
        service.host = "https://example.com"
        
        await #expect(throws: URLError.self) {
            try await service.getCategories()
        }
    }
}
