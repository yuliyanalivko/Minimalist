import RealmSwift
import Realm

enum RealmConfigurationFactory {
    /// The current Realm schema version.
    ///
    /// Increment this value whenever the Realm schema changes in a way
    /// that requires a migration.
    static let schemaVersion: UInt64 = 1
    
    /// Creates the Realm configuration for the application.
    ///
    /// The configuration includes the current schema version, migration handler, and all Realm object
    /// types persisted by the application.
    ///
    /// - Returns: A configured `Realm.Configuration` instance.
    static func make() -> Realm.Configuration {
        Realm.Configuration(
            schemaVersion: schemaVersion,
            migrationBlock: migrate,
            objectTypes: [
                RealmCategory.self,
                RealmItem.self,
                RealmItemDetails.self,
                RealmSubCategory.self,
                RealmReview.self
            ]
        )
    }
    
    /// Performs any required changes when migrating from an older schema.
    ///
    /// Use this closure to update persisted objects when the Realm schema changes between versions.
    ///
    /// - Parameters:
    ///   - migration: The migration object used to modify persisted data.
    ///   - oldSchemaVersion: The schema version from which the migration starts.
    private static func migrate(_ migration: Migration, _ oldSchemaVersion: UInt64) {}
}
