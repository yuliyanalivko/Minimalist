import Foundation
import Testing
@testable import Minimalist

struct CategoryServiceTests {

    private func makeService(
        handler: @escaping MockURLProtocol.Handler
    ) -> CategoryService {
        let httpClient = TestHTTPClientFactory.make(handler: handler)

        return CategoryService(
            client: CatalogDataProvider(
                httpClient: HTTPCatalogClient(client: httpClient)
            )
        )
    }

    @Test("Should return decoded categories")
    func getCategories_returnCategories() async throws {
        let json = mockCategories.data(using: .utf8)!

        let service = makeService { request in
            #expect(request.url?.path == "/api/v1/categories")
            #expect(request.httpMethod == "GET")

            return (TestHTTPClientFactory.httpResponse(for: request, statusCode: 200), json)
        }

        let categories = try await service.getCategories()

        #expect(categories.count == 1)
        #expect(categories.first?.id == "1")
        #expect(categories.first?.name == "Sofas")
    }

    @Test("Should throw server error")
    func getCategories_throwServerError() async {
        let service = makeService { request in
            (TestHTTPClientFactory.httpResponse(for: request, statusCode: 500), Data())
        }

        await #expect {
            _ = try await service.getCategories()
        } throws: { error in
            guard case .serverError(let code, _) = error as? NetworkError else { return false }

            return code == 500
        }
    }
}
