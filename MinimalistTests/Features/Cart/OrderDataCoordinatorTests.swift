import Foundation
import Testing
@testable import Minimalist

@MainActor
struct OrderDataCoordinatorTests {

    private func makeCoordinator(
        mockData: Data?,
        mockError: Error? = nil
    ) -> (OrderDataCoordinator, MockNetworkClient) {
        let mockClient = MockNetworkClient(mockData: mockData, mockError: mockError)
        let coordinator = OrderDataCoordinator(
            networkService: OrderNetworkService(networkClient: mockClient)
        )
        
        return (coordinator, mockClient)
    }
    
    @Test("Should create an order on success")
    func createOrder_succeeds() async throws {
        let (coordinator, mockClient) = makeCoordinator(mockData: Data())

        try await coordinator.createOrder(order: order)

        #expect(mockClient.lastRequest?.httpMethod == "POST")
        #expect(mockClient.lastRequest?.url?.path == "/api/v1/order")
    }

    @Test("Should throw network error when creating an order fails")
    func createOrder_throwNetworkError() async {
        let (coordinator, _) = makeCoordinator(
            mockData: nil,
            mockError: URLError(.badServerResponse)
        )

        do {
            try await coordinator.createOrder(order: order)
            Issue.record("Expected error")
        } catch let error as MinimalistError {
            guard case .networkError = error else {
                Issue.record("Expected networkError, got \(error)")
                
                return
            }

            #expect(error.localizedDescription == "The server returned an unexpected response. Please try again later.")
        } catch {
            Issue.record("Expected MinimalistError, got \(error)")
        }
    }
    
    @Test("Should throw mapping error when decoding fails")
    func createOrder_throwMappingError() async {
        let context = DecodingError.Context(codingPath: [], debugDescription: "Test decoding failure")
        let (coordinator, _) = makeCoordinator(
            mockData: nil,
            mockError: DecodingError.dataCorrupted(context)
        )

        do {
            try await coordinator.createOrder(order: order)
            Issue.record("Expected error")
        } catch let error as MinimalistError {
            guard case .mappingError = error else {
                Issue.record("Expected mappingError, got \(error)")
                
                return
            }

            #expect(error.localizedDescription == "We couldn't load the data. Please try again.")
        } catch {
            Issue.record("Expected MinimalistError, got \(error)")
        }
    }
    
    @Test("Should throw unknown error for an unhandled failure")
    func createOrder_throwUnknownError() async {
        struct CustomTestError: Error {}
        let (coordinator, _) = makeCoordinator(
            mockData: nil,
            mockError: CustomTestError()
        )

        do {
            try await coordinator.createOrder(order: order)
            Issue.record("Expected error")
        } catch let error as MinimalistError {
            guard case .unknown = error else {
                Issue.record("Expected unknown, got \(error)")
                
                return
            }

            #expect(error.localizedDescription == "Something went wrong. Please try again.")
        } catch {
            Issue.record("Expected MinimalistError, got \(error)")
        }
    }
}
