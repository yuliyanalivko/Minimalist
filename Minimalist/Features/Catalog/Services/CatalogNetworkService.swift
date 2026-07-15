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
    
    func getItems(categoryId: String) async throws -> Data {
        let url = try NetworkRequestBuilder.build(
            host: host,
            servicePath: servicePath,
            version: version,
            queryItems: ["categories" : categoryId],
            path: "search"
        )
        
        let request = URLRequest(url: url, method: .get)

        return try await execute(request)
    }
    
    func getItemDetails(id: String) async throws -> Data {
        let url = try NetworkRequestBuilder.build(
            host: host,
            servicePath: servicePath,
            version: version,
            queryItems: ["id" : id],
            path: "item/details"
        )
        
        var request = URLRequest(url: url, method: .get)
        request.setValue("9b7135f6-c435-4b37-8456-bcb9c812b128", forHTTPHeaderField: "User-ID")

        return try await execute(request)
    }
}
