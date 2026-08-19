import SwiftData
import Foundation

@Model
final class SwiftDataItemDetails: Persistable, EntityIdentified, Expirable {
    @Attribute(.unique)
    var entityId: String
    
    var name: String
    var category: Category?
    var subCategory: SubCategory?
    var itemDescription: String
    var rating: Double
    var isFavorited: Bool
    var isAddedToCart: Bool
    var price: Double
    var thumbnails: [String]
    var reviews: [Review] = []
    var cachedAt: Date
    
    init(
        entityId: String,
        name: String,
        category: Category?,
        subCategory: SubCategory?,
        itemDescription: String,
        rating: Double,
        isFavorited: Bool,
        isAddedToCart: Bool,
        price: Double,
        thumbnails: [String],
        reviews: [Review] = []
    ) {
        self.entityId = entityId
        self.name = name
        self.category = category
        self.subCategory = subCategory
        self.itemDescription = itemDescription
        self.rating = rating
        self.isFavorited = isFavorited
        self.isAddedToCart = isAddedToCart
        self.price = price
        self.thumbnails = thumbnails
        self.reviews = reviews
        self.cachedAt = Date()
    }
    
    convenience init(from dto: ItemDetails) {
        self.init(
            entityId: dto.id,
            name: dto.name,
            category: dto.category,
            subCategory: dto.subCategory,
            itemDescription: dto.description,
            rating: dto.rating,
            isFavorited: dto.isFavorited,
            isAddedToCart: dto.isAddedToCart,
            price: dto.price,
            thumbnails: dto.thumbnails,
            reviews: dto.reviews ?? []
        )
    }
}
