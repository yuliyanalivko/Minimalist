import Foundation
@testable import Minimalist

enum TestHTTPClientFactory {
    static func make(
        baseURL: URL = URL(string: "https://example.com")!,
        token: String = UUID().uuidString,
        handler: @escaping MockURLProtocol.Handler
    ) -> URLSessionHTTPClient {
        MockURLProtocol.register(token: token, handler: handler)

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        config.httpAdditionalHeaders = [MockURLProtocol.tokenHeader: token]

        let session = URLSession(configuration: config)

        return URLSessionHTTPClient(baseURL: baseURL, session: session)
    }

    static func httpResponse(for request: URLRequest, statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(
            url: request.url!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }
}
