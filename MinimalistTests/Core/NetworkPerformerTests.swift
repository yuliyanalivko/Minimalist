import Testing
import Foundation
@testable import Minimalist

struct URLSessionNetworkPerformerTests {
    
    private func makeMockSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        
        return URLSession(configuration: configuration)
    }

    @Test("Should successfully return data when HTTP status code is 2xx")
    func execute_withValidStatusCode_returnsData() async throws {
        let session = makeMockSession()
        let url = URL(string: "https://example.com/categories")!
        var request = URLRequest(url: url)
        
        let testToken = UUID().uuidString
        request.setValue(testToken, forHTTPHeaderField: MockURLProtocol.tokenHeader)
        
        let expectedData = mockCategories.data(using: .utf8)!
        
        MockURLProtocol.register(token: testToken) { _ in
            return (
                HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!,
                expectedData
            )
        }
        
        defer { MockURLProtocol.unregister(token: testToken) }
        
        let receivedData = try await session.execute(request: request)
        
        #expect(receivedData == expectedData)
    }

    @Test(
        "Should throw badServerResponse error when HTTP status code is not 2xx",
        arguments: [301, 400, 401, 404, 500]
    )
    func execute_withInvalidStatusCode_throwsBadServerResponse(statusCode: Int) async throws {
        let session = makeMockSession()
        let url = URL(string: "https://api.example.com/categories")!
        var request = URLRequest(url: url)
        
        let testToken = "\(UUID().uuidString)-\(statusCode)"
        request.setValue(testToken, forHTTPHeaderField: MockURLProtocol.tokenHeader)
        
        MockURLProtocol.register(token: testToken) { _ in
            return (
                HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!,
                Data()
            )
        }
        
        defer { MockURLProtocol.unregister(token: testToken) }
        
        await #expect(throws: URLError(.badServerResponse)) {
            try await session.execute(request: request)
        }
    }
}
