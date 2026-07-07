import Foundation
import Testing
@testable import Minimalist

struct HTTPCatalogClientTests {

    private func makeClient(
        handler: @escaping MockURLProtocol.Handler
    ) -> HTTPCatalogClient {
        let httpClient = TestHTTPClientFactory.make(handler: handler)

        return HTTPCatalogClient(client: httpClient)
    }

    @Test("Should cal api/v1/categories for categories")
    func getCategories_useCorrectEndpoint() async throws {
        let json = mockCategories.data(using: .utf8)!

        let client = makeClient { request in
            #expect(request.url?.path == "/api/v1/categories")
            #expect(request.httpMethod == "GET")

            return (TestHTTPClientFactory.httpResponse(for: request, statusCode: 200), json)
        }

        let categories = try await client.getCategories()

        #expect(categories.count == 1)
        #expect(categories.first?.id == "1")
        #expect(categories.first?.name == "Sofas")
    }
}
