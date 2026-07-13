import Foundation

@Observable
final class CatalogDataCoordinator: BaseDataCoordinator {
    private let networkService: CatalogNetworkService    
    
    init(networkService: CatalogNetworkService = CatalogNetworkService()) {
        self.networkService = networkService
    }
    
    func getCategories() async throws -> [Category] {
        do {
            let data = try await networkService.getCategories()
                        
            return try JSONDecoder().decode([Category].self, from: data)
        } catch {
            throw convert(error: error)
        }
    }
}
