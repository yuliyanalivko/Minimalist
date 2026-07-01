import Foundation

protocol CategoryProviding {
    func getCategories() async throws -> [Category]
}

final class CategoryService: CategoryProviding {
    private let client: APIClient
    
    init(client: APIClient = MinimalistAPIClient()) {
        self.client = client
    }
    
    func getCategories() async throws -> [Category] {
        try await client.getCategories()
    }
}

