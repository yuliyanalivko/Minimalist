import Foundation

@Observable
final class OrderDataCoordinator: BaseDataCoordinator {
    private let networkService: OrderNetworkService
    private let storeResolver: () -> CartStoring
    
    private var store: CartStoring {
        storeResolver()
    }

    init(
        networkService: OrderNetworkService = OrderNetworkService(),
        storeResolver: @escaping () -> CartStoring = { StoreFactory.makeStore() }
    ) {
        self.networkService = networkService
        self.storeResolver = storeResolver
    }
    
    func createOrder(order: OrderRequest) async throws {
        do {
            try await networkService.createOrder(order: order)
            
            /// Ideally isAddedToCart should change only for the ordered items, but the server removes all items from the cart anyway
            let items = try store.getCartItems()
            
            for item in items {
                try store.setAddedToCart(id: item.id, isAddedToCart: false)
            }
            
        } catch {
            throw convert(error: error)
        }
    }
}
