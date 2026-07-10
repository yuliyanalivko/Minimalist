import Foundation
@testable import Minimalist

final class MockNetworkClient: NetworkPerformer, @unchecked Sendable {
    var mockResponseData: Data?
    var mockError: Error?
    
    init(mockData: Data?, mockError: Error? = nil) {
        self.mockResponseData = mockData
        self.mockError = mockError
    }

    func execute(request: URLRequest) async throws -> Data {
        if let mockError {
            throw mockError
        }

        guard let mockResponseData else {
            throw URLError(.badServerResponse)
        }

        return mockResponseData
    }
}
