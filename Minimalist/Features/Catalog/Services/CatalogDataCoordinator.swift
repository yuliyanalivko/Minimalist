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
    
    func getItems(categoryId: String) async throws -> [Item] {
        do {
            let data = try await networkService.getItems(categoryId: categoryId)
                        
            return try JSONDecoder().decode([Item].self, from: data)
        } catch {
            throw convert(error: error)
        }
    }
    
    func getItemDetails(id: String) async throws -> ItemDetails {
        do {
            let data = try await networkService.getItemDetails(id: id)
                        
            return try JSONDecoder().decode(ItemDetails.self, from: data)
        } catch {
            throw convert(error: error)
        }
    }
}
