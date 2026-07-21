import Foundation

@Observable
final class CartDataCoordinator: BaseDataCoordinator {
    private let networkService: CartNetworkService
    
    init(networkService: CartNetworkService = CartNetworkService()) {
        self.networkService = networkService
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
        } catch {
            throw convert(error: error)
        }
    }
    
    func removeFromCart(id: String) async throws {
        do {
            _ = try await networkService.removeFromCart(id: id)
        } catch {
            throw convert(error: error)
        }
    }
}
