import Foundation
@testable import Minimalist

final class MockCacheCleaner: CacheCleaning, @unchecked Sendable {
    private(set) var deletedOlderThan: Date?
    var deleteError: Error?
    
    func deleteExpired(olderThan date: Date) throws {
        if let deleteError {
            throw deleteError
        }
        
        deletedOlderThan = date
    }
}
