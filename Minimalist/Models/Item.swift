struct Item: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let category: Category?
    let subcategory: SubCategory?
    let rating: Double
    var isFavorited: Bool
    var isAddedToCart: Bool
    let price: Double
    var thumbnailUrl: String?
    
    func toRealm() -> RealmItem {
        RealmItem(from: self)
    }
    
    func toSwiftData() -> SwiftDataItem {
        SwiftDataItem(from: self)
    }
}

extension Item {
    init(from entity: RealmItem) {
        self.init(
            id: entity.id,
            name: entity.name,
            category: entity.category.map { Category(from: $0) },
            subcategory: entity.subcategory.map { SubCategory(from: $0) },
            rating: entity.rating,
            isFavorited: entity.isFavorited,
            isAddedToCart: entity.isAddedToCart,
            price: entity.price,
            thumbnailUrl: entity.thumbnailUrl,
        )
    }
    
    init(from entity: SwiftDataItem) {
        self.init(
            id: entity.entityId,
            name: entity.name,
            category: entity.category,
            subcategory: entity.subcategory,
            rating: entity.rating,
            isFavorited: entity.isFavorited,
            isAddedToCart: entity.isAddedToCart,
            price: entity.price,
            thumbnailUrl: entity.thumbnailUrl,
        )
    }
}
