import Foundation
@testable import Minimalist

final class MockHTTPClient: HTTPClient, @unchecked Sendable {
    private(set) var lastPath: String?
    
    var getResult: Result<Data, Error>?
    
    func get<T: Decodable>(
        _ path: String,
        query: [String: String]?,
        headers: [String: String]?
    ) async throws -> T {
        lastPath = path
        
        return try await returnValue()
    }
    
    func post<T: Decodable, Body: Encodable>(
        _ path: String, query: [String: String]?, headers: [String: String]?, body: Body
    ) async throws -> T {
        lastPath = path
        
        return try await returnValue()
    }
    
    func put<T: Decodable, Body: Encodable>(
        _ path: String, query: [String: String]?, headers: [String: String]?, body: Body
    ) async throws -> T {
        lastPath = path
        
        return try await returnValue()
    }
    
    func delete(_ path: String, query: [String: String]?, headers: [String: String]?) async throws {
        lastPath = path
    }
    
    private func returnValue<T: Decodable>() async throws -> T {
        switch getResult {
        case .success(let data):
            return try JSONDecoder().decode(T.self, from: data)
        case .failure(let error):
            throw error
        case nil:
            throw URLError(.badURL)
        }
    }
}
