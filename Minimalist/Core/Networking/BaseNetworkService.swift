import Foundation

protocol BaseNetworkService: AnyObject {
    /// The root domain endpoint for the network calls.
    var host: String { get }
    /// An optional intermediate gateway prefix or environment path component (e.g., `/api`)..
    var servicePath: String? { get }
    /// The current API system version to route against (e.g., `.v1`).
    var version: NetworkServiceVersion { get }
    /// The network transport engine used to dispatch outgoing requests.
    var networkClient: NetworkPerformer { get set }
}

extension BaseNetworkService {
    /// Dispatches a prepared network request through the configured network runner.
    /// - Parameter request: The fully configured `URLRequest` destined for the server.
    /// - Returns: Raw response `Data` returned from a successful network task execution.
    func execute(_ request: URLRequest) async throws -> Data {
        try await networkClient.execute(request: request)
    }
}
