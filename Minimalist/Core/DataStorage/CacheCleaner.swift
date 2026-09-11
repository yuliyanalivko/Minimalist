import Foundation
import SwiftData

protocol CacheCleaning {
    func deleteExpired(olderThan date: Date) throws
}

@MainActor
final class CacheCleaner: CacheCleaning {
    private let realmDatabaseManager: DatabaseManaging
    private let swiftDataContainer: ModelContainer?
    
    init(
        realmDatabaseManager: DatabaseManaging = RealmDatabaseManager(),
        swiftDataContainer: ModelContainer? = nil
    ) {
        self.realmDatabaseManager = realmDatabaseManager
        self.swiftDataContainer = swiftDataContainer
    }
    
    /// Deletes expired catalog cache records from Realm and, when available, SwiftData.
    /// - Parameter date: Cutoff date; records with `cachedAt` older than this are removed.
    func deleteExpired(olderThan date: Date) throws {
        try realmDatabaseManager.delete(type: RealmCategory.self, olderThan: date)
        try realmDatabaseManager.delete(type: RealmItem.self, olderThan: date)
        try realmDatabaseManager.delete(type: RealmItemDetails.self, olderThan: date)
        
        guard let swiftDataContainer else {
            return
        }
        
        let swiftDataDatabaseManager = SwiftDataDatabaseManager(container: swiftDataContainer)
        
        try swiftDataDatabaseManager.delete(type: SwiftDataCategory.self, olderThan: date)
        try swiftDataDatabaseManager.delete(type: SwiftDataItem.self, olderThan: date)
        try swiftDataDatabaseManager.delete(type: SwiftDataItemDetails.self, olderThan: date)
    }
}
