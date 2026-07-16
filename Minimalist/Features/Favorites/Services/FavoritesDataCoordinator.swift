import Foundation

@Observable
final class FavoritesDataCoordinator: BaseDataCoordinator {
    private let networkService: FavoritesNetworkService
    
    init(networkService: FavoritesNetworkService = FavoritesNetworkService()) {
        self.networkService = networkService
    }
    
    func getFavorites() async throws -> [Item] {
        try await requestData({
            try await networkService.getFavorites()
        }, as: [Item].self)
    }
    
    func addToFavorites(id: String) async throws {
        try await request {
            try await networkService.addToFavorites(id: id)
        }
    }
    
    func removeFromFavorites(id: String) async throws {
        try await request {
            try await networkService.removeFromFavorites(id: id)
        }
    }
}
