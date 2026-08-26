import SwiftData
import Foundation

enum MigrationPlan: SchemaMigrationPlan {
    /// The schema versions that are included in this migration plan
    ///
    /// The schemas should be listed in their migration order, from the oldest supported version to the
    /// newest.
    static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self]
    }
    
    /// The migration stages used to migrate between schema versions
    ///
    /// Example:
    /// ```swift
    /// [MigrationStage.lightweight(
    ///     fromVersion: SchemaV1.self,
    ///     toVersion: SchemaV2.self
    /// )]
    ///
    /// static var stages: [MigrationStage] {
    ///     [migrateV1toV2]
    /// }
    /// ```
    static var stages: [MigrationStage] {
        []
    }
}
