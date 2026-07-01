import Foundation
import Testing
@testable import Minimalist

struct CategoryServiceTests {
    
    private let categoriesJSON = """
    [{"id":"1","name":"Sofas","thumbnailUrl":null,"subCategories":[]}]
    """.data(using: .utf8)!
    
    @Test("Should return decoded categories")
    func getCategories_returnCategories() async throws {
        let mock = MockAPIClient()
        let result = [Category(id: "1", name: "Sofas", thumbnailUrl: nil, subCategories: [])]
        mock.getResult = .success(result)
        let service = CategoryService(client: mock)
        
        let categories = try await service.getCategories()
        
        #expect(categories == result)
    }
    
    @Test("Should throw error")
    func getCategories_throwError() async {
        let mock = MockAPIClient()
        mock.getResult = .failure(NetworkError.transportError(underlying: URLError(.notConnectedToInternet)))
        let service = CategoryService(client: mock)
        
        await #expect(throws: NetworkError.self) {
            _ = try await service.getCategories()
        }
    }
}
