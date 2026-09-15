import Foundation

@Observable
final class CartDataCoordinator: BaseDataCoordinator {
    private let networkService: CartNetworkService
    
    private let storeResolver: () -> CartStoring
    
    private var store: CartStoring {
        storeResolver()
    }
    
    init(
        networkService: CartNetworkService = CartNetworkService(),
        storeResolver: @escaping () -> CartStoring = { StoreFactory.makeStore() }
    ) {
        self.networkService = networkService
        self.storeResolver = storeResolver
    }
    
    func getCartItems() async throws -> [Item] {
        do {
            let data = try await networkService.getCartItems()
            
            return try JSONDecoder().decode([Item].self, from: data)
        } catch {
            throw convert(error: error)
        }
    }
    
    func addToCart(id: String) async throws {
        do {
            _ = try await networkService.addToCart(id: id)
            try store.setAddedToCart(id: id, isAddedToCart: true)
        } catch {
            throw convert(error: error)
        }
    }
    
    func removeFromCart(id: String) async throws {
        do {
            _ = try await networkService.removeFromCart(id: id)
            try store.setAddedToCart(id: id, isAddedToCart: false)
        } catch {
            throw convert(error: error)
        }
    }
}
