enum AppError {
    case noInternet
    case unknown
    case server
    
    var message: String {
        switch self {
        case .noInternet:
            return "No internet connection. Please try again."
        case .server:
            return "Server is not responding. Try later."
        case .unknown:
            return "Something went wrong."
        }
    }
}
