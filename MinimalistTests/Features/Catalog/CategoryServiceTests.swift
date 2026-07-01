import Foundation
import Testing
@testable import Minimalist

struct CategoryServiceTests {
    
    private let categoriesJSON = """
    [{"id":"1","name":"Sofas","thumbnailUrl":null,"subCategories":[]}]
    """.data(using: .utf8)!
    
    @Test("Should return decoded categories")
    func getCategories_returnCategories() async throws {
        let client = MockCatalogAPIClient()
        let result = [Category(id: "1", name: "Sofas", thumbnailUrl: nil, subCategories: [])]
        client.getResult = .success(result)
        let service = CategoryService(client: CatalogDataProvider(httpClient: client))
        
        let categories = try await service.getCategories()
        
        #expect(categories == result)
    }
    
    @Test("Should throw error")
    func getCategories_throwError() async {
        let client = MockCatalogAPIClient()
        client.getResult = .failure(NetworkError.transportError(underlying: URLError(.notConnectedToInternet)))
        let service = CategoryService(client: CatalogDataProvider(httpClient: client))
        
        await #expect(throws: NetworkError.self) {
            _ = try await service.getCategories()
        }
    }
}
