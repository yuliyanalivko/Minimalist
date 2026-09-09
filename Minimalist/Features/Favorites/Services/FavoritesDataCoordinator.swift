import Foundation

@Observable
final class FavoritesDataCoordinator: BaseDataCoordinator {
    private let networkService: FavoritesNetworkService
    private let storeResolver: () -> FavoritesStoring
    
    private var store: FavoritesStoring {
        storeResolver()
    }
    
    init(
        networkService: FavoritesNetworkService = FavoritesNetworkService(),
        storeResolver: @escaping () -> FavoritesStoring = { StoreFactory.makeStore() }
    ) {
        self.networkService = networkService
        self.storeResolver = storeResolver
    }
    
    func getFavorites() -> AsyncThrowingStream<[Item], Error> {
        AsyncThrowingStream { continuation in
            Task {
                if let cached = try? store.getFavorites(), !cached.isEmpty {
                    continuation.yield(cached)
                }
                
                do {
                    let data = try await networkService.getFavorites()
                    let items = try JSONDecoder().decode([Item].self, from: data)
                    
                    try store.save(items)
                    
                    continuation.yield(items)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: convert(error: error))
                }
            }
        }
    }
    
    func addToFavorites(id: String) async throws {
        do {
            _ = try await networkService.addToFavorites(id: id)
            try store.setFavorited(id: id, isFavorited: true)
        } catch {
            throw convert(error: error)
        }
    }
    
    func removeFromFavorites(id: String) async throws {
        do {
            _ = try await networkService.removeFromFavorites(id: id)
            try store.setFavorited(id: id, isFavorited: false)
        } catch {
            throw convert(error: error)
        }
    }
}
