import Foundation

@Observable
final class CatalogDataCoordinator: BaseDataCoordinator {
    private let networkService: CatalogNetworkService
    private let favoritesNetworkService: FavoritesNetworkService
    private let cartNetworkService: CartNetworkService
    
    init(
        networkService: CatalogNetworkService = CatalogNetworkService(),
        favoritesNetworkService: FavoritesNetworkService = FavoritesNetworkService(),
        cartNetworkService: CartNetworkService = CartNetworkService()
    ) {
        self.networkService = networkService
        self.favoritesNetworkService = favoritesNetworkService
        self.cartNetworkService = cartNetworkService
    }
    
    func getCategories() async throws -> [Category] {
        try await requestData({
            try await networkService.getCategories()
        }, as: [Category].self)
    }
    
    func getItems(categoryId: String) async throws -> [Item] {
        try await requestData({
            try await networkService.getItems(categoryId: categoryId)
        }, as: [Item].self)
    }
    
    func getItemDetails(id: String) async throws -> ItemDetails {
        try await requestData({
            try await networkService.getItemDetails(id: id)
        }, as: ItemDetails.self)
    }
    
    func addToFavorites(id: String) async throws {
        try await request {
            try await favoritesNetworkService.addToFavorites(id: id)
        }
    }
    
    func removeFromFavorites(id: String) async throws {
        try await request {
            try await favoritesNetworkService.removeFromFavorites(id: id)
        }
    }
    
    func addToCart(id: String) async throws {
        try await request {
            try await cartNetworkService.addToCart(id: id)
        }
    }
    
    func removeFromCart(id: String) async throws {
        try await request {
            try await cartNetworkService.removeFromCart(id: id)
        }
    }
}
