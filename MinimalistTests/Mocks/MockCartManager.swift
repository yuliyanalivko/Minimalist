import Foundation
@testable import Minimalist

final class MockCartManager: CartManaging {
    var items: [Item]
    
    var itemCount: Int {
        items.count
    }
    
    init(items: [Item] = []) {
        self.items = items
    }
    
    func loadCartItems() {}
    
    func getCartItems() -> AsyncThrowingStream<[Item], any Error> {
        let (stream, continuation) = AsyncThrowingStream<[Item], any Error>.makeStream()
        
        continuation.yield([item, item2])
        
        continuation.finish()
        
        return stream
    }
    
    func addToCart(id: String) async throws {}
    
    func removeFromCart(id: String) async throws {}
}
