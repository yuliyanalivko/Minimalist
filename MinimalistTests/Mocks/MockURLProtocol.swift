import Foundation

final class MockURLProtocol: URLProtocol {
    typealias Handler = (URLRequest) throws -> (HTTPURLResponse, Data)

    static let tokenHeader = "X-Mock-Token"

    nonisolated(unsafe) private static var handlers: [String: Handler] = [:]
    private static let lock = NSLock()

    static func register(token: String, handler: @escaping Handler) {
        lock.lock()
        defer { lock.unlock() }
        handlers[token] = handler
    }

    static func unregister(token: String) {
        lock.lock()
        defer { lock.unlock() }
        handlers[token] = nil
    }

    private static func handler(for token: String) -> Handler? {
        lock.lock()
        defer { lock.unlock() }
        return handlers[token]
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard
            let token = request.value(forHTTPHeaderField: Self.tokenHeader),
            let handler = Self.handler(for: token)
        else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
