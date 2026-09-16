import Foundation

@Observable
final class OrderDataCoordinator: BaseDataCoordinator {
    private let networkService: OrderNetworkService
    
    init(
        networkService: OrderNetworkService = OrderNetworkService(),
    ) {
        self.networkService = networkService
    }
    
    func createOrder(order: OrderRequest) async throws {
        do {
            try await networkService.createOrder(order: order)
        } catch {
            throw convert(error: error)
        }
    }
}
