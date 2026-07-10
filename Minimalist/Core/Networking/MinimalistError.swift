import Foundation

enum MinimalistError: Error, LocalizedError {
    /// Represents an issue during data transport (e.g., timeout, lost connection, or bad server response).
    /// - Parameter error: The underlying system or network error causing the failure.
    case networkError(error: Error)
    /// Represents a failure while serializing or parsing data (e.g., a `DecodingError` from JSON parsing).
    /// - Parameter error: The underlying parsing error containing the schema mismatch details.
    case mappingError(error: Error)
    /// A fallback case used when an unexpected failure occurs that does not match known categories.
    case unknown
    
    /// A localized, end-user readable description of the error.
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return networkErrorDescription(error: error)
            
        case .mappingError:
            return "We couldn't load the data. Please try again."
            
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
    
    private func networkErrorDescription(error: Error) -> String {
        guard let urlError = error as? URLError else {
            return "Something went wrong. Please try again."
        }
        
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
            return "Please check your internet connection and try again."
            
        case .timedOut:
            return "The request took too long. Please try again."
            
        case .cannotFindHost, .cannotConnectToHost, .dnsLookupFailed:
            return "We couldn't reach the server. Please try again later."
            
        case .badServerResponse:
            return "The server returned an unexpected response. Please try again later."
            
        case .badURL, .unsupportedURL:
            return "The URL provided was invalid."
            
        case .cancelled:
            return "The request was cancelled."
            
        default:
            return "Something went wrong. Please try again."
        }
    }
}
