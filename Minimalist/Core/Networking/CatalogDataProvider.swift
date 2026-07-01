import Foundation

struct CatalogDataProvider {
    private let httpClient: CatalogAPIClient
    
    init(httpClient: CatalogAPIClient = HTTPCatalogClient()) {
        self.httpClient = httpClient
    }
    
    func getCategories() async throws -> [Category] {
        try await httpClient.getCategories()
    }
}
