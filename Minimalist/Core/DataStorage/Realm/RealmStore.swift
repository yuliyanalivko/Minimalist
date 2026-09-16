final class RealmStore: CacheStoring {
    private let databaseManager: DatabaseManaging
    
    init(databaseManager: DatabaseManaging = RealmDatabaseManager()) {
        self.databaseManager = databaseManager
    }
    
    /// Fetches all stored categories from the Realm database and maps them to domain models.
    /// - Returns: An array of `Category` domain objects.
    func getCategories() throws -> [Category] {
        let entities = try databaseManager.get(type: RealmCategory.self, sort: .name)
        
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
        let entities = try databaseManager.get(type: RealmItem.self, sort: .name)
        
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
    
    /// Fetches stored favorite items from the Realm database and maps them to domain models.
    /// - Returns: An array of `Item` domain objects marked as favorited.
    func getFavorites() throws -> [Item] {
        let entities = try databaseManager.get(type: RealmItem.self, sort: .name)
            .filter(\.isFavorited)
        
        return entities.map { Item(from: $0) }
    }
    
    /// Updates the favorited status of a specific item and its details, when cached, in the database.
    /// - Parameters:
    ///   - id: The unique identifier of the item to update.
    ///   - isFavorited: Boolean value indicating whether the item should be marked as favorited or not
    func setFavorited(id: String, isFavorited: Bool) throws {
        try databaseManager.update(type: RealmItem.self, id: id) { item in
            item.isFavorited = isFavorited
        }
        
        try databaseManager.update(type: RealmItemDetails.self, id: id) { details in
            details.isFavorited = isFavorited
        }
    }
    
    /// Updates the cart status of a specific item in the database.
    /// - Parameters:
    ///   - id: The unique identifier of the `RealmItem` to update.
    ///   - isAddedToCart: Boolean value indicating whether the item should be marked as added to cart or not.
    func setAddedToCart(id: String, isAddedToCart: Bool) throws {
        try databaseManager.update(type: RealmItem.self, id: id) { item in
            item.isAddedToCart = isAddedToCart
        }
        
        try databaseManager.update(type: RealmItemDetails.self, id: id) { details in
            details.isAddedToCart = isAddedToCart
        }
    }
    
    
    /// Fetches stored cart items from the Realm database and maps them to domain models.
    /// - Returns: An array of `Item` domain objects marked as added to cart.
    func getCartItems() throws -> [Item] {
        let entities = try databaseManager.get(type: RealmItem.self, sort: .name)
            .filter(\.isAddedToCart)
        
        return entities.map { Item(from: $0) }
    }
}

