import RealmSwift
import Foundation

class RealmItemDetails: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var category: RealmCategory?
    @Persisted var subCategory: RealmSubCategory?
    @Persisted var itemDescription: String
    @Persisted var rating: Double
    @Persisted var isFavorited: Bool
    @Persisted var isAddedToCart: Bool
    @Persisted var price: Double
    @Persisted var thumbnails: List<String> = List()
    @Persisted var reviews: List<RealmReview> = List()
    @Persisted var cachedAt: Date = Date()

    convenience init(from dto: ItemDetails) {
        self.init()
        self.id = dto.id
        self.name = dto.name
        
        if let category = dto.category {
            self.category = RealmCategory(from: category)
        }
        
        if let subCategory = dto.subCategory {
            self.subCategory = RealmSubCategory(from: subCategory)
        }
        
        self.itemDescription = dto.description
        self.rating = dto.rating
        self.isFavorited = dto.isFavorited
        self.isAddedToCart = dto.isAddedToCart
        self.price = dto.price
        self.thumbnails.append(objectsIn: dto.thumbnails)
        
        if let reviews = dto.reviews {
            self.reviews
                .append(objectsIn: reviews.map { RealmReview(from: $0) })
        }
        
        self.cachedAt = Date()
    }
}
