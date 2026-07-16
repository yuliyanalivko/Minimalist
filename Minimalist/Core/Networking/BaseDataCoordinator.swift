import Foundation

class BaseDataCoordinator {
    /// Transforms raw network system errors or data parsing failures into standard app errors.
    /// - Parameter error: The raw error caught from the network client or JSON decoder.
    /// - Returns: A categorized `MinimalistError` containing localized user messages.
    func convert(error: Error) -> MinimalistError {
        if let minimalistError = error as? MinimalistError {
            return minimalistError
        }
        
        if error is DecodingError {
            return .mappingError(error: error)
        }
        
        if error is URLError {
            return .networkError(error: error)
        }
        
        return .unknown
    }
}
