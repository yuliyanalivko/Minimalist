import Foundation
import RealmSwift

@Observable
final class CatalogDataCoordinator: BaseDataCoordinator {
    private let networkService: CatalogNetworkService
    private let databaseManager: DatabaseManaging
    
    init(
        networkService: CatalogNetworkService = CatalogNetworkService(),
        databaseManager: DatabaseManaging = DatabaseManager()
    ) {
        self.networkService = networkService
        self.databaseManager = databaseManager
    }
    
    /// Fetches category data using a cache-first strategy over an asynchronous stream.
    ///
    /// This method operates in two stages:
    /// 1. Immediately emits non-empty cached categories from the local database (if available).
    /// 2. Fetches fresh categories from the remote server after a delay, updates the local database,
    /// emits the updated list, and completes the stream.
    ///
    /// - Returns: An `AsyncThrowingStream` emitting up to two updates of category lists.
    func getCategories() -> AsyncThrowingStream<[Category], Error> {
        AsyncThrowingStream { continuation in
            Task {
                if let entities = try? databaseManager.get(type: CategoryEntity.self) {
                    let cached = entities.map { Category(from: $0) }
                    
                    if !cached.isEmpty {
                        continuation.yield(cached)
                    }
                }
                
                do {
                    let data = try await networkService.getCategories()
                    let categories = try JSONDecoder().decode([Category].self, from: data)
                    
                    try databaseManager.save(categories.map { $0.toEntity() })
                    
                    continuation.yield(categories)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: convert(error: error))
                }
            }
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
