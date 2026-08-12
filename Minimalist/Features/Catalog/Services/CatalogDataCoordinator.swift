import Foundation

@Observable
final class CatalogDataCoordinator: BaseDataCoordinator {
    private let networkService: CatalogNetworkService
    private let storeResolver: () -> CatalogStoring
    
    private var catalogStore: CatalogStoring {
        storeResolver()
    }
    
    init(
        networkService: CatalogNetworkService = CatalogNetworkService(),
        storeResolver: @escaping () -> CatalogStoring = { CatalogStoreFactory.makeStore() }
    ) {
        self.networkService = networkService
        self.storeResolver = storeResolver
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
                if let cached = try? catalogStore.getCategories(), !cached.isEmpty {
                    continuation.yield(cached)
                }
                
                do {
                    let data = try await networkService.getCategories()
                    let categories = try JSONDecoder().decode([Category].self, from: data)
                    
                    try catalogStore.save(categories)
                    
                    continuation.yield(categories)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: convert(error: error))
                }
            }
        }
    }
    
    /// Fetches item data using a cache-first strategy over an asynchronous stream.
    ///
    /// This method operates in two stages:
    /// 1. Immediately emits non-empty cached items from the local database (if available).
    /// 2. Fetches fresh items from the remote server after a delay, updates the local database,
    /// emits the updated list, and completes the stream.
    ///
    /// - Parameter categoryId: The unique identifier of the category used to retrieve its associated items.
    /// - Returns: An `AsyncThrowingStream` emitting up to two updates of item lists.
    func getItems(categoryId: String) -> AsyncThrowingStream<[Item], Error> {
        AsyncThrowingStream { continuation in
            Task {
                if let entities = try? catalogStore.getItems() {
                    let cached = entities
                        .filter { $0.category?.id == categoryId }
                    
                    if !cached.isEmpty {
                        continuation.yield(cached)
                    }
                }
                
                do {
                    let data = try await networkService.getItems(categoryId: categoryId)
                    let items = try JSONDecoder().decode([Item].self, from: data)
                    
                    try catalogStore.save(items)
                    
                    continuation.yield(items)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: convert(error: error))
                }
            }
        }
    }
    
    /// Fetches item details using a cache-first strategy over an asynchronous stream.
    ///
    /// This method operates in two stages:
    /// 1. Immediately emits non-nil cached item details from the local database (if available).
    /// 2. Fetches fresh item details from the remote server after a delay, updates the local database,
    /// emits the updated entity, and completes the stream.
    ///
    /// - Parameter id: The unique identifier of the required item.
    /// - Returns: An `AsyncThrowingStream` emitting up to two updates of item details.
    func getItemDetails(id: String) -> AsyncThrowingStream<ItemDetails, Error> {
        AsyncThrowingStream { continuation in
            Task {
                if let cached = try? catalogStore.getItemDetails(id: id) {
                    continuation.yield(cached)
                }
                
                do {
                    let data = try await networkService.getItemDetails(id: id)
                    let itemDetails = try JSONDecoder().decode(ItemDetails.self, from: data)
                    
                    try catalogStore.save(itemDetails)
                    
                    continuation.yield(itemDetails)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: convert(error: error))
                }
            }
        }
    }
}
