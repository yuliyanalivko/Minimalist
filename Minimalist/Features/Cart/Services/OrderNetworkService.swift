import Foundation

class OrderNetworkService: BaseNetworkService {
    var host: String = APIConfiguration.hostURL
    var version: NetworkServiceVersion = .v1
    var servicePath: String? = "/api"
    var networkClient: NetworkPerformer
    
    init(networkClient: NetworkPerformer = URLSession.shared) {
        self.networkClient = networkClient
    }

    func createOrder(order: OrderRequest) async throws {
        let url = try NetworkRequestBuilder.build(
            host: host,
            servicePath: servicePath,
            version: version,
            path: "order"
        )
        
        let json = try JSONEncoder().encode(order)

        var request = URLRequest(url: url, method: .post, body: json)
        request.setValue("9b7135f6-c435-4b37-8456-bcb9c812b128", forHTTPHeaderField: "User-ID")
        
        _ = try await execute(request)
    }
}
