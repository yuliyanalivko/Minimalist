import Foundation

enum HTTPRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

extension URLRequest {
    /// Initializes and pre-configures a standardized `URLRequest` for REST API interactions.
    /// - Parameters:
    ///   - url: The targeted destination `URL` for the transaction.
    ///   - method: The HTTP method to use for the request (e.g., .get, .post).
    ///   - body: An optional raw `Data` payload destined for the server body stream.
    init(url: URL, method: HTTPRequestMethod, body: Data? = nil) {
        self.init(url: url)
        httpMethod = method.rawValue
        httpBody = body
        setValue("application/json", forHTTPHeaderField: "Accept")
        
        if body != nil {
            setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}
