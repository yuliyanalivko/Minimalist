import Foundation

protocol CategoryProviding {
    func getCategories() async throws -> [Category]
}

final class CategoryService: CategoryProviding {
    private let client: CatalogDataProvider
    
    init(client: CatalogDataProvider = CatalogDataProvider()) {
        self.client = client
    }
    
    func getCategories() async throws -> [Category] {
        try await client.getCategories()
    }
}

