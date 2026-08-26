import SwiftData
import Foundation

enum SchemaV1: VersionedSchema {
    /// The unique version identifier for the schema.
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    /// The persistent models that belong to the schema
    static var models: [any PersistentModel.Type] {
        [SwiftDataCategory.self, SwiftDataItem.self, SwiftDataItemDetails.self]
    }
}
