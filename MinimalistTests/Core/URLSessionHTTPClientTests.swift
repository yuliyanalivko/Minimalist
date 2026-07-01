import Foundation
import Testing
@testable import Minimalist

@Suite(.serialized)
struct URLSessionHTTPClientTests {
    
    private let baseURL = URL(string: "https://example.com")!
    
    private struct TestPayload: Codable, Equatable {
        let id: Int
        let name: String
    }
    
    private struct TestRequestBody: Encodable, Equatable, Decodable {
        let name: String
    }
    
    private func makeClient() -> URLSessionHTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        URLProtocol.registerClass(MockURLProtocol.self)
        
        return URLSessionHTTPClient(
            baseURL: baseURL,
            session: URLSession(configuration: configuration)
        )
    }
    
    private func httpResponse(for request: URLRequest, statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
    @Test("Should decode a successful JSON response")
    func get_decodeSuccessResponse() async throws {
        MockURLProtocol.requestHandler = { request in
            (self.httpResponse(for: request, statusCode: 200), #"{"id":1,"name":"Sofas"}"#.data(using: .utf8)!)
        }
        
        let result: TestPayload = try await makeClient().get("api/v1/categories")
        #expect(result == TestPayload(id: 1, name: "Sofas"))
    }
    
    @Test("Should build URL with path and query")
    func get_buildURLWithQuery() async throws {
        var capturedRequest: URLRequest?
        MockURLProtocol.requestHandler = { request in
            capturedRequest = request
            
            return (self.httpResponse(for: request, statusCode: 200), #"{"id":1,"name":"Test"}"#.data(using: .utf8)!)
        }
        
        let _: TestPayload = try await makeClient().get("/api/v1/categories", query: ["page": "1"])
        
        #expect(capturedRequest?.httpMethod == "GET")
        #expect(capturedRequest?.url?.path == "/api/v1/categories")
        #expect(capturedRequest?.url?.query?.contains("page=1") == true)
    }
    
    @Test("Should throw emptyResponse when body is empty")
    func get_throwEmptyResponse() async {
        MockURLProtocol.requestHandler = { request in
            (self.httpResponse(for: request, statusCode: 200), Data())
        }
        
        await #expect {
            let _: TestPayload = try await makeClient().get("api/v1/categories")
        } throws: { error in
            guard let networkError = error as? NetworkError else { return false }
            
            if case .emptyResponse = networkError {
                return true
            }
            
            return false
        }
    }
    
    @Test("Should throw serverError on non-2xx status")
    func get_throwServerError() async {
        MockURLProtocol.requestHandler = { request in
            (self.httpResponse(for: request, statusCode: 404), Data())
        }
        
        do {
            let _: TestPayload = try await makeClient().get("missing")
            Issue.record("Expected serverError")
        } catch let error as NetworkError {
            if case .serverError(let code, _) = error {
                #expect(code == 404)
            } else {
                Issue.record("Expected serverError, got \(error)")
            }
        } catch {
            Issue.record("Expected serverError, but got an unexpected error type: \(error)")
        }
    }
    
    @Test("Should throw decodingError for invalid JSON")
    func get_throwDecodingError() async {
        MockURLProtocol.requestHandler = { request in
            (self.httpResponse(for: request, statusCode: 200), #"{"id":"bad"}"#.data(using: .utf8)!)
        }
        
        do {
            let _: TestPayload = try await makeClient().get("api/v1/categories")
            Issue.record("Expected decodingError")
        } catch let error as NetworkError {
            guard case .decodingError = error else {
                Issue.record("Expected decodingError, got \(error)")
                
                return
            }
        } catch {
            Issue.record("Expected decodingError, but got an unexpected error type: \(error)")
        }
    }
    
    @Test("Should send encoded JSON body")
    func post_sendEncodedBody() async throws {
        var capturedRequest: URLRequest?
        MockURLProtocol.requestHandler = { request in
            capturedRequest = request
            
            return (self.httpResponse(for: request, statusCode: 200), #"{"id":1,"name":"Created"}"#.data(using: .utf8)!)
        }
        
        let _: TestPayload = try await makeClient().post(
            "api/v1/categories",
            body: TestRequestBody(name: "Created")
        )
        
        #expect(capturedRequest?.httpMethod == "POST")
    }
    
    @Test("Should succeed with empty response body")
    func delete_succeedWithEmptyBody() async throws {
        var capturedRequest: URLRequest?
        MockURLProtocol.requestHandler = { request in
            capturedRequest = request
            
            return (self.httpResponse(for: request, statusCode: 204), Data())
        }
        
        try await makeClient().delete("api/v1/categories/1")
        #expect(capturedRequest?.httpMethod == "DELETE")
    }
}
