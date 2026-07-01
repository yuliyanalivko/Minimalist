import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case emptyResponse
    case decodingError(underlying: Error)
    case encodingError(underlying: Error)
    case transportError(underlying: Error)
    case serverError(statusCode: Int, data: Data?)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .invalidResponse:
            return "Received an unexpected response from the server."
        case .emptyResponse:
            return "The server returned an empty response."
        case .decodingError:
            return "Failed to decode the server data."
        case .encodingError:
            return "Failed to encode the request payload."
        case .transportError:
            return "A network error occurred."
        case .serverError(let code, _):
            return "Server returned an error status code: \(code)."
        }
    }
}
