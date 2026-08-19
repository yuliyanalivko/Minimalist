final class RealmCatalogStore: CatalogStoring {
    private let databaseManager: DatabaseManaging
    
    init(databaseManager: DatabaseManaging = RealmDatabaseManager()) {
        self.databaseManager = databaseManager
    }
    
    /// Fetches all stored categories from the Realm database and maps them to domain models.
    /// - Returns: An array of `Category` domain objects.
    func getCategories() throws -> [Category] {
        let entities = try databaseManager.get(type: RealmCategory.self, sort: true)
        
        return entities.map { Category(from: $0) }
    }
    
    /// Converts an array of category domain models to Realm persistent models and saves them to the database.
    /// - Parameter categories: An array of `Category` domain objects.
    func save(_ categories: [Category]) throws {
        let entities = categories.map { $0.toRealm() }
        try  databaseManager.save(entities)
    }
    
    /// Fetches all stored items from the Realm database and maps them to domain models.
    /// - Returns: An array of `Item` domain objects.
    func getItems() throws -> [Item] {
        let entities = try databaseManager.get(type: RealmItem.self, sort: true)
        
        return entities.map { Item(from: $0) }
    }
    
    /// Converts an array of item domain models to Realm persistent models and saves them to the database.
    /// - Parameter items: An array of `Item` domain objects.
    func save(_ items: [Item]) throws {
        let entities = items.map { $0.toRealm() }
        try databaseManager.save(entities)
    }
    
    /// Fetches item details for a specific unique identifier from the Realm database and maps the result to a domain model.
    /// - Parameter id: The unique identifier matching the requested item details.
    /// - Returns: An `ItemDetails` domain object if found in Realm and mapped successfully; otherwise, `nil`.
    func getItemDetails(id: String) throws -> ItemDetails? {
        guard let entity = try databaseManager.get(type: RealmItemDetails.self, id: id) else {
            return nil
        }
        
        return ItemDetails(from: entity)
    }
    
    /// Converts an item details domain model to a Realm persistent model and saves it to the database.
    /// - Parameter itemDetails: The `ItemDetails` domain object.
    func save(_ itemDetails: ItemDetails) throws {
        try databaseManager.save(itemDetails.toRealm())
    }
}

