import Foundation

protocol NetworkPerformer: Sendable {
    func execute(request: URLRequest) async throws -> Data
}

extension URLSession: NetworkPerformer {
    /// Executes a network request. Enforces successful HTTP status codes before releasing data to the application.
    /// - Parameter request: The target `URLRequest` to fulfill.
    /// - Returns: The downloaded server payload data.
    func execute(request: URLRequest) async throws -> Data {
        let (data, response) = try await data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }

        return data
    }
}
