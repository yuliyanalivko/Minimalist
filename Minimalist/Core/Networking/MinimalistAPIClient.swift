import Foundation

class MinimalistAPIClient: APIClient {
    private let client: HTTPClient
    
    private let apiV1 = "api/v1/"
    private let categories = "categories"
    
    init(client: HTTPClient = URLSessionHTTPClient()) {
        self.client = client
    }
    
    func getCategories() async throws -> [Category] {
        try await client.get(apiV1 + categories)
    }
}

protocol APIClient {
    func getCategories() async throws -> [Category]
}
