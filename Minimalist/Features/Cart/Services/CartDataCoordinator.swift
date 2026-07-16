import Foundation

@Observable
final class CartDataCoordinator: BaseDataCoordinator {
    private let networkService: CartNetworkService
    
    init(networkService: CartNetworkService = CartNetworkService()) {
        self.networkService = networkService
    }
    
    func getCartItems() async throws -> [Item] {
        try await requestData({
            try await networkService.getCartItems()
        }, as: [Item].self)
    }
    
    func addToCart(id: String) async throws {
        try await request {
            try await networkService.addToCart(id: id)
        }
    }
    
    func removeFromCart(id: String) async throws {
        try await request {
            try await networkService.removeFromCart(id: id)
        }
    }
}
