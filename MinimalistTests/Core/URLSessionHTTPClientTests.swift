import Foundation
import Testing
@testable import Minimalist

struct URLSessionHTTPClientTests {

    private struct TestPayload: Codable, Equatable {
        let id: Int
        let name: String
    }

    private struct TestRequestBody: Encodable, Equatable, Decodable {
        let name: String
    }

    @Test("Should decode a successful JSON response")
    func get_decodeSuccessResponse() async throws {
        let json = mockCategories.data(using: .utf8)!
        let expected = try JSONDecoder().decode([Minimalist.Category].self, from: json)

        let client = TestHTTPClientFactory.make { request in
            (TestHTTPClientFactory.httpResponse(for: request, statusCode: 200), json)
        }

        let result: [Minimalist.Category] = try await client.get("api/v1/categories")

        #expect(result == expected)
    }

    @Test("Should build URL with path and query")
    func get_buildURLWithQuery() async throws {
        let capturedRequest = CapturedRequest()

        let client = TestHTTPClientFactory.make { request in
            capturedRequest.value = request

            return (TestHTTPClientFactory.httpResponse(for: request, statusCode: 200), mockCategories.data(using: .utf8)!)
        }

        let _: [Minimalist.Category] = try await client.get("/api/v1/categories", query: ["page": "1"])

        #expect(capturedRequest.value?.httpMethod == "GET")
        #expect(capturedRequest.value?.url?.path == "/api/v1/categories")
        #expect(capturedRequest.value?.url?.query?.contains("page=1") == true)
    }

    @Test("Should throw emptyResponse when body is empty")
    func get_throwEmptyResponse() async {
        let client = TestHTTPClientFactory.make { request in
            (TestHTTPClientFactory.httpResponse(for: request, statusCode: 200), Data())
        }

        await #expect {
            let _: TestPayload = try await client.get("api/v1/categories")
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
        let client = TestHTTPClientFactory.make { request in
            (TestHTTPClientFactory.httpResponse(for: request, statusCode: 404), Data())
        }

        do {
            let _: TestPayload = try await client.get("missing")
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
        let client = TestHTTPClientFactory.make { request in
            (TestHTTPClientFactory.httpResponse(for: request, statusCode: 200), #"{"id":"bad"}"#.data(using: .utf8)!)
        }

        do {
            let _: TestPayload = try await client.get("api/v1/categories")
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
        let capturedRequest = CapturedRequest()

        let client = TestHTTPClientFactory.make { request in
            capturedRequest.value = request

            return (TestHTTPClientFactory.httpResponse(for: request, statusCode: 200), #"{"id":1,"name":"Created"}"#.data(using: .utf8)!)
        }

        let _: TestPayload = try await client.post(
            "api/v1/categories",
            body: TestRequestBody(name: "Created")
        )

        #expect(capturedRequest.value?.httpMethod == "POST")
    }

    @Test("Should succeed with empty response body")
    func delete_succeedWithEmptyBody() async throws {
        let capturedRequest = CapturedRequest()

        let client = TestHTTPClientFactory.make { request in
            capturedRequest.value = request

            return (TestHTTPClientFactory.httpResponse(for: request, statusCode: 204), Data())
        }

        try await client.delete("api/v1/categories/1")
        #expect(capturedRequest.value?.httpMethod == "DELETE")
    }
}

private final class CapturedRequest: @unchecked Sendable {
    var value: URLRequest?
}
