import SwiftData
import Foundation

@Model
final class SwiftDataItem: Persistable, EntityIdentified, Expirable {
    @Attribute(.unique)
    var entityId: String
    
    var name: String
    var category: Category?
    var subcategory: SubCategory?
    var rating: Double
    var isFavorited: Bool
    var isAddedToCart: Bool
    var price: Double
    var thumbnailUrl: String?
    var cachedAt: Date
    
    init(
        entityId: String,
        name: String,
        category: Category?,
        subcategory: SubCategory?,
        rating: Double,
        isFavorited: Bool,
        isAddedToCart: Bool,
        price: Double,
        thumbnailUrl: String?
    ) {
        self.entityId = entityId
        self.name = name
        self.category = category
        self.subcategory = subcategory
        self.rating = rating
        self.isFavorited = isFavorited
        self.isAddedToCart = isAddedToCart
        self.price = price
        self.thumbnailUrl = thumbnailUrl
        self.cachedAt = Date()
    }
    
    convenience init(from dto: Item) {
        self.init(
            entityId: dto.id,
            name: dto.name,
            category: dto.category,
            subcategory: dto.subcategory,
            rating: dto.rating,
            isFavorited: dto.isFavorited,
            isAddedToCart: dto.isAddedToCart,
            price: dto.price,
            thumbnailUrl: dto.thumbnailUrl
        )
    }
}
