import Foundation
import Testing
@testable import Minimalist

struct CartNetworkServiceTests {

    private func makeService(mockData: Data?, mockError: Error? = nil) -> (CartNetworkService, MockNetworkClient) {
        let mockClient = MockNetworkClient(mockData: mockData, mockError: mockError)
        let service = CartNetworkService(networkClient: mockClient)
        service.host = "https://example.com"
        
        return (service, mockClient)
    }

    @Test("Should call api/v1/cart on get")
    func getCartItems_useCorrectEndpoint() async throws {
        let json = mockItems.data(using: .utf8)!
        let (service, mockClient) = makeService(mockData: json)

        _ = try await service.getCartItems()

        #expect(mockClient.lastRequest?.httpMethod == "GET")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/cart")
    }

    @Test("Should POST to api/v1/cart when adding")
    func addToCart_useCorrectEndpoint() async throws {
        let (service, mockClient) = makeService(mockData: Data())

        try await service.addToCart(id: "item-1")

        #expect(mockClient.lastRequest?.httpMethod == "POST")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/cart")
    }

    @Test("Should DELETE from api/v1/cart with id query when removing")
    func removeFromCart_useCorrectEndpoint() async throws {
        let (service, mockClient) = makeService(mockData: Data())

        try await service.removeFromCart(id: "1")

        #expect(mockClient.lastRequest?.httpMethod == "DELETE")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/cart")
        #expect(mockClient.lastRequest?.url?.query?.contains("id=1") == true)
    }

    @Test("Should forward the network error when the client fails")
    func getCartItems_onFailure_throwForwardedError() async {
        let expectedError = URLError(.notConnectedToInternet)
        let (service, _) = makeService(mockData: nil, mockError: expectedError)

        await #expect(throws: URLError.self) {
            try await service.getCartItems()
        }
    }
}
