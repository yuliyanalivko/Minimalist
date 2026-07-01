import Foundation
import Testing
@testable import Minimalist

struct MinimalistAPIClientTests {
    
    private let json = "[]".data(using: .utf8)!
    
    @MainActor
    @Test("Should cal api/v1/categories for categories")
    func getCategories_useCorrectEndpoint() async throws {
        let httpClient = MockHTTPClient()
        httpClient.getResult = .success(json)
        let apiClient = MinimalistAPIClient(client: httpClient)
        
        _ = try await apiClient.getCategories()
        
        #expect(httpClient.lastPath == "api/v1/categories")
    }
}
