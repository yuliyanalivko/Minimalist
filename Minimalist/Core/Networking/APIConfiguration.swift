import Foundation

enum APIConfiguration {
    static var hostURL: URL {
        guard let url = URL(string: "http://127.0.0.1:8080/") else {
            fatalError("Incorrect Host URL")
        }
        
        return url
    }
}
