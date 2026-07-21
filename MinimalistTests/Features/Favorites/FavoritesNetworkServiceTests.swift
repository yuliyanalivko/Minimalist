import Foundation
import Testing
@testable import Minimalist

struct FavoritesNetworkServiceTests {

    private func makeService(mockData: Data?, mockError: Error? = nil) -> (FavoritesNetworkService, MockNetworkClient) {
        let mockClient = MockNetworkClient(mockData: mockData, mockError: mockError)
        let service = FavoritesNetworkService(networkClient: mockClient)
        service.host = "https://example.com"
        
        return (service, mockClient)
    }

    @Test("Should call api/v1/favorites on get")
    func getFavorites_useCorrectEndpoint() async throws {
        let json = mockItems.data(using: .utf8)!
        let (service, mockClient) = makeService(mockData: json)

        _ = try await service.getFavorites()

        #expect(mockClient.lastRequest?.httpMethod == "GET")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/favorites")
    }

    @Test("Should POST to api/v1/favorites when adding")
    func addToFavorites_useCorrectEndpoint() async throws {
        let (service, mockClient) = makeService(mockData: Data())

        try await service.addToFavorites(id: "1")

        #expect(mockClient.lastRequest?.httpMethod == "POST")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/favorites")
    }

    @Test("Should DELETE from api/v1/favorites with id query when removing")
    func removeFromFavorites_useCorrectEndpoint() async throws {
        let (service, mockClient) = makeService(mockData: Data())

        try await service.removeFromFavorites(id: "1")

        #expect(mockClient.lastRequest?.httpMethod == "DELETE")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/favorites")
        #expect(mockClient.lastRequest?.url?.query?.contains("id=1") == true)
    }

    @Test("Should forward the network error when the client fails")
    func getFavorites_onFailure_throwForwardedError() async {
        let expectedError = URLError(.notConnectedToInternet)
        let (service, _) = makeService(mockData: nil, mockError: expectedError)

        await #expect(throws: URLError.self) {
            try await service.getFavorites()
        }
    }
}
