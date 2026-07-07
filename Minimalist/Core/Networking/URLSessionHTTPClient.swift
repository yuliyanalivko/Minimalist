import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol HTTPClient: Sendable {
    func get<T: Decodable>(
        _ path: String,
        query: [String: String]?,
        headers: [String: String]?
    ) async throws -> T
    
    func post<T: Decodable, Body: Encodable>(
        _ path: String,
        query: [String: String]?,
        headers: [String: String]?,
        body: Body
    ) async throws -> T
    
    func put<T: Decodable, Body: Encodable>(
        _ path: String,
        query: [String: String]?,
        headers: [String: String]?,
        body: Body
    ) async throws -> T
    
    func delete(
        _ path: String,
        query: [String: String]?,
        headers: [String: String]?
    ) async throws
}

extension HTTPClient {
    func get<T: Decodable>(
        _ path: String,
        query: [String: String]? = nil
    ) async throws -> T {
        try await get(path, query: query, headers: nil)
    }
    
    func post<T: Decodable, Body: Encodable>(
        _ path: String,
        query: [String: String]? = nil,
        body: Body
    ) async throws -> T {
        try await post(path, query: query, headers: nil, body: body)
    }
    
    func put<T: Decodable, Body: Encodable>(
        _ path: String,
        query: [String: String]? = nil,
        body: Body
    ) async throws -> T {
        try await put(path, query: query, headers: nil, body: body)
    }
    
    func delete(
        _ path: String,
        query: [String: String]? = nil
    ) async throws {
        try await delete(path, query: query, headers: nil)
    }
}

/// A networking client powered by Swift Concurrency and `URLSession`.
///
/// Handles the core work for all network requests. It standardizes how
/// the app builds URLs, manages HTTP headers, processes JSON data,
/// and validates server response codes.
struct URLSessionHTTPClient: HTTPClient {
    private let baseURL: URL
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    init(
        baseURL: URL = APIConfiguration.hostURL,
        session: URLSession = .shared,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder(),
    ) {
        self.baseURL = baseURL
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
    }
    
    /// Performs an asynchronous HTTP GET request and decodes the JSON response.
    /// - Parameters:
    ///   - path: The relative URL endpoint path for the request.
    ///   - query: An optional dictionary of URL query key-value pairs to append to the request string.
    ///   - headers: An optional dictionary of custom HTTP request headers to attach to the network task.
    /// - Returns: A fully initialized instance of type `T` populated from the decoded network payload.
    func get<T: Decodable>(
        _ path: String,
        query: [String: String]?,
        headers: [String: String]?
    ) async throws -> T {
        let request = try buildRequest(path: path, method: .get, query: query, headers: headers)
        
        return try await fetch(for: request)
    }
    
    /// Performs an asynchronous HTTP POST request, encoding a request body and decoding the JSON response.
    /// - Parameters:
    ///   - path: The relative URL endpoint path for the request.
    ///   - query: An optional dictionary of URL query key-value pairs to append to the request string.
    ///   - headers: An optional dictionary of custom HTTP request headers to attach to the network task.
    ///   - body: The `Encodable` object to be serialized into JSON and sent in the HTTP request body.
    /// - Returns: A fully initialized instance of type `T` populated from the decoded network payload.
    func post<T: Decodable, Body: Encodable>(
        _ path: String,
        query: [String: String]?,
        headers: [String: String]?,
        body: Body
    ) async throws -> T {
        let request = try buildRequest(path: path, method: .post, query: query, headers: headers, body: body)
        
        return try await fetch(for: request)
    }
    
    /// Performs an asynchronous HTTP PUT request, encoding an update body and decoding the JSON response.
    /// - Parameters:
    ///   - path: The relative URL endpoint path for the resource being updated.
    ///   - query: An optional dictionary of URL query key-value pairs to append to the request string.
    ///   - headers: An optional dictionary of custom HTTP request headers to attach to the network task.
    ///   - body: The `Encodable` object containing updated data to be serialized into JSON and sent in the request body.
    /// - Returns: A fully initialized instance of type `T` representing the updated resource state.
    func put<T: Decodable, Body: Encodable>(
        _ path: String,
        query: [String: String]?,
        headers: [String: String]?,
        body: Body
    ) async throws -> T {
        let request = try buildRequest(path: path, method: .put, query: query, headers: headers, body: body)
        
        return try await fetch(for: request)
    }
    
    /// Performs an asynchronous HTTP DELETE request where no response body is expected.
    /// - Parameters:
    ///   - path: The relative URL endpoint path for the resource to be deleted.
    ///   - query: An optional dictionary of URL query key-value pairs to append to the request string.
    ///   - headers: An optional dictionary of custom HTTP request headers to attach to the network task.
    func delete(
        _ path: String,
        query: [String: String]?,
        headers: [String: String]?
    ) async throws {
        let request = try buildRequest(path: path, method: .delete, query: query, headers: headers)
        
        _ = try await fetchNoContent(for: request)
    }
    
    private func fetch<T: Decodable>(for request: URLRequest) async throws -> T {
        let data = try await fetchNoContent(for: request)
        
        guard !data.isEmpty else {
            throw NetworkError.emptyResponse
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(underlying: error)
        }
    }
    
    private func fetchNoContent(for request: URLRequest) async throws -> Data {
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.transportError(underlying: error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(
                statusCode: httpResponse.statusCode,
                data: data.isEmpty ? nil : data
            )
        }
        
        return data
    }
    
    private func buildRequest(
        path: String,
        method: HTTPMethod,
        query: [String: String]?,
        headers: [String: String]?
    ) throws -> URLRequest {
        let url = try buildURL(path: path, query: query)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
    private func buildRequest<Body: Encodable>(
        path: String,
        method: HTTPMethod,
        query: [String: String]?,
        headers: [String: String]?,
        body: Body
    ) throws -> URLRequest {
        var request = try buildRequest(path: path, method: method, query: query, headers: nil)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            throw NetworkError.encodingError(underlying: error)
        }
        
        return request
    }
    
    private func buildURL(path: String, query: [String: String]?) throws -> URL {
        let normalizedPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        
        guard var components = URLComponents(
            url: baseURL.appending(path: normalizedPath),
            resolvingAgainstBaseURL: false
        ) else {
            throw NetworkError.invalidURL
        }
        
        if let query, !query.isEmpty {
            components.queryItems = query
                .map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
}
