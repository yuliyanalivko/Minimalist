import SwiftData

enum StoreFactory {
    /// Creates a `CatalogStoring` instance for the given storage engine.
    /// - Parameters:
    ///   - storageEngine: Preferred cache storage engine. Defaults to the value in `UserSettings`.
    ///   - swiftDataContainer: SwiftData container used when `storageEngine` is `.swiftData`.
    ///     Defaults to `AppConfigurationManager.shared.swiftDataContainer`.
    /// - Returns: A `SwiftDataCatalogStore` when SwiftData is selected and a container is available;
    ///   otherwise a `RealmCatalogStore`.
    static func makeStore(
        storageEngine: CacheStorageEngine = UserSettings().storageEngine,
        swiftDataContainer: ModelContainer? = AppConfigurationManager.shared.swiftDataContainer
    ) -> CacheStoring {
        guard storageEngine == .swiftData,
              let container = swiftDataContainer else {
            return RealmStore()
        }
        
        return SwiftDataCatalogStore(container: container)
    }
}

