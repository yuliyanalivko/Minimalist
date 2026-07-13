import Foundation

enum NetworkRequestBuilder {
    /// Constructs and normalizes a complete `URL` from its separate architectural segments.
    /// - Parameters:
    ///   - host: The root server endpoint.
    ///   - servicePath: An optional internal proxy directory or domain gateway (e.g., `/api`).
    ///   - version: The release tag version of the service target framework layer( e.g., `.v1`).
    ///   - queryItems: An optional dictionary containing URL key-value filter parameters. Defaults to empty.
    ///   - path: The explicit network resource or action path location (e.g., `"/categories/"`)..
    /// - Returns: A formatted, system-valid `URL`.
    static func build(
        host: String,
        servicePath: String?,
        version: NetworkServiceVersion,
        queryItems: [String: String] = [:],
        path: String
    ) throws -> URL {
        var urlString = host.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        if let servicePath, !servicePath.isEmpty {
            let normalizedServicePath = servicePath.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
            urlString += "/\(normalizedServicePath)"
        }

        if !version.rawValue.isEmpty {
            urlString += "/\(version.rawValue)"
        }

        let normalizedPath = path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        urlString += "/\(normalizedPath)"

        guard var components = URLComponents(string: urlString) else {
            throw MinimalistError.networkError(error: URLError(.badURL))
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        guard let url = components.url else {
            throw MinimalistError.networkError(error: URLError(.badURL))
        }

        return url
    }
}
