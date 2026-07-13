import Foundation

class CatalogNetworkService: BaseNetworkService {
    var host: String = APIConfiguration.hostURL
    var version: NetworkServiceVersion = .v1
    var servicePath: String? = "/api"
    var networkClient: NetworkPerformer

    init(networkClient: NetworkPerformer = URLSession.shared) {
        self.networkClient = networkClient
    }

    func getCategories() async throws -> Data {
        let url = try NetworkRequestBuilder.build(
            host: host,
            servicePath: servicePath,
            version: version,
            path: "categories"
        )
        
        let request = URLRequest(url: url, method: .get)

        return try await execute(request)
    }
}
