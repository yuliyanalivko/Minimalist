struct ItemDetails: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let category: Category?
    let subCategory: SubCategory?
    let description: String
    let rating: Double
    var isFavorited: Bool
    var isAddedToCart: Bool
    let price: Double
    var thumbnails: [String]
    let reviews: [Review]?
    
    func toEntity() -> ItemDetailsEntity {
        ItemDetailsEntity(from: self)
    }
}

extension ItemDetails {
    init(from entity: ItemDetailsEntity) {
        let reviews = Array(entity.reviews.map { Review(from: $0) })
        let thumbnails = Array(entity.thumbnails.map { $0 })
        
        self.init(
            id: entity.id,
            name: entity.name,
            category: entity.category.map { Category(from: $0) },
            subCategory: entity.subCategory.map { SubCategory(from: $0) },
            description: entity.itemDescription,
            rating: entity.rating,
            isFavorited: entity.isFavorited,
            isAddedToCart: entity.isAddedToCart,
            price: entity.price,
            thumbnails: thumbnails,
            reviews: reviews,
        )
    }
}
