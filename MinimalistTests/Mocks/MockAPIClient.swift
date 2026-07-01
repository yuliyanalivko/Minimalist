import Foundation
@testable import Minimalist

final class MockAPIClient: APIClient {
    var getResult: Result<[Minimalist.Category], Error>?

    func getCategories() async throws -> [Minimalist.Category] {
        switch getResult {
        case .success(let categories):
            return categories
        case .failure(let error):
            throw error
        case nil:
            throw URLError(.badURL)
        }
    }
}
