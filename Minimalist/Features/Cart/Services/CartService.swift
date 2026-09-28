import Foundation

protocol CartManaging {
    var items: [Item] { get }
    var itemCount: Int { get }
    
    func loadCartItems() async
    func getCartItems() -> AsyncThrowingStream<[Item], Error>
    func addToCart(id: String) async throws
    func removeFromCart(id: String) async throws
}

@Observable
final class CartService: CartManaging {
    var itemCount: Int {
        items.count
    }
    
    private(set) var items: [Item] = []
    
    private let dataCoordinator: CartDataCoordinator
    
    init(dataCoordinator: CartDataCoordinator = CartDataCoordinator()) {
        self.dataCoordinator = dataCoordinator
    }
    
    func loadCartItems() async {
        do {
            for try await _ in getCartItems() {}
        } catch {}
    }
    
    func getCartItems() -> AsyncThrowingStream<[Item], Error> {
        AsyncThrowingStream { continuation in
            let task = Task {
                do {
                    for try await fetchedItems in dataCoordinator.getCartItems() {
                        items = fetchedItems
                        continuation.yield(fetchedItems)
                    }
                    
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
    
    func addToCart(id: String) async throws {
        try await dataCoordinator.addToCart(id: id)
        await loadCartItems()
    }
    
    func removeFromCart(id: String) async throws {
        try await dataCoordinator.removeFromCart(id: id)
        items.removeAll { $0.id == id }
    }
}
