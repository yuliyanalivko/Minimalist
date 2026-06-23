import Foundation
@testable import Minimalist

final class MockImageDataFetcher: ImageDataFetching, @unchecked Sendable {
    var resultsByURL: [URL: Result<Data, Error>] = [:]
    var defaultResult: Result<Data, Error> = .failure(URLError(.unknown))
    
    private(set) var requestedURLs: [URL] = []
    
    convenience init(result: Result<Data, Error>) {
        self.init()
        self.defaultResult = result
    }
    
    func data(from url: URL) async throws -> Data {
        requestedURLs.append(url)
        let result = resultsByURL[url] ?? defaultResult
        
        return try result.get()
    }
}
