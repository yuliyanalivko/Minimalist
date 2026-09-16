import Foundation
import Testing
@testable import Minimalist

@MainActor
struct OrderNetworkServiceTests {

    private func makeService(mockData: Data?, mockError: Error? = nil) -> (OrderNetworkService, MockNetworkClient) {
        let mockClient = MockNetworkClient(mockData: mockData, mockError: mockError)
        let service = OrderNetworkService(networkClient: mockClient)
        service.host = "https://example.com"
        
        return (service, mockClient)
    }

    @Test("Should call to api/v1/order endpoint")
    func createOrder_useCorrectEndpoint() async throws {
        let (service, mockClient) = makeService(mockData: Data())

        try await service.createOrder(order: order)

        #expect(mockClient.lastRequest?.httpMethod == "POST")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/order")
        #expect(mockClient.lastRequest?.value(forHTTPHeaderField: "User-ID") == "9b7135f6-c435-4b37-8456-bcb9c812b128")
    }
    
    @Test("Should encode the order in the request body")
    func createOrder_encodeRequestBody() async throws {
        let (service, mockClient) = makeService(mockData: Data())

        try await service.createOrder(order: order)

        guard let body = mockClient.lastRequest?.httpBody else {
            Issue.record("Expected request body not to be nil")
            
            return
        }
        
        let decoded = try JSONDecoder().decode(OrderRequest.self, from: body)
        
        #expect(decoded.username == order.username)
        #expect(decoded.city == order.city)
        #expect(decoded.country == order.country)
        #expect(decoded.address == order.address)
        #expect(decoded.zipcode == order.zipcode)
        #expect(decoded.items == order.items)
    }

    @Test("Should forward the network error when the client fails")
    func createOrder_onFailure_throwForwardedError() async {
        let expectedError = URLError(.notConnectedToInternet)
        let (service, _) = makeService(mockData: nil, mockError: expectedError)

        await #expect(throws: URLError.self) {
            try await service.createOrder(order: order)
        }
    }
}
