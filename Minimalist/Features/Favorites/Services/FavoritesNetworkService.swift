import Foundation

class FavoritesNetworkService: BaseNetworkService {
    var host: String = APIConfiguration.hostURL
    var version: NetworkServiceVersion = .v1
    var servicePath: String? = "/api"
    var networkClient: NetworkPerformer
    
    init(networkClient: NetworkPerformer = URLSession.shared) {
        self.networkClient = networkClient
    }
    
    func getFavorites() async throws -> Data {
        let url = try NetworkRequestBuilder.build(
            host: host,
            servicePath: servicePath,
            version: version,
            path: "favorites"
        )
        
        var request = URLRequest(url: url, method: .get)
        request.setValue("9b7135f6-c435-4b37-8456-bcb9c812b128", forHTTPHeaderField: "User-ID")
        
        return try await execute(request)
    }
    
    func addToFavorites(id: String) async throws {
        let url = try NetworkRequestBuilder.build(
            host: host,
            servicePath: servicePath,
            version: version,
            path: "favorites"
        )
        
        let json = try JSONSerialization.data(withJSONObject: ["id": id], options: [])
        
        var request = URLRequest(url: url, method: .post, body: json)
        request.setValue("9b7135f6-c435-4b37-8456-bcb9c812b128", forHTTPHeaderField: "User-ID")
        
        _ = try await execute(request)
    }
    
    func removeFromFavorites(id: String) async throws {
        let url = try NetworkRequestBuilder.build(
            host: host,
            servicePath: servicePath,
            version: version,
            queryItems: ["id" : id],
            path: "favorites"
        )
        
        var request = URLRequest(url: url, method: .delete)
        request.setValue("9b7135f6-c435-4b37-8456-bcb9c812b128", forHTTPHeaderField: "User-ID")
        
        _ = try await execute(request)
    }
}
