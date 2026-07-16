import Foundation

@Observable
final class FavoritesDataCoordinator: BaseDataCoordinator {
    private let networkService: FavoritesNetworkService
    
    init(networkService: FavoritesNetworkService = FavoritesNetworkService()) {
        self.networkService = networkService
    }

    func getFavorites() async throws -> [Item] {
        do {
            let data = try await networkService.getFavorites()
            
            return try JSONDecoder().decode([Item].self, from: data)
        } catch {
            throw convert(error: error)
        }
    }
    
    func addToFavorites(id: String) async throws {
        do {
            _ = try await networkService.addToFavorites(id: id)
        } catch {
            throw convert(error: error)
        }
    }
    
    func removeFromFavorites(id: String) async throws {
        do {
            _ = try await networkService.removeFromFavorites(id: id)
        } catch {
            throw convert(error: error)
        }
    }
}
