import RealmSwift

class ItemDetailsEntity: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var category: CategoryEntity?
    @Persisted var subCategory: SubCategoryEntity?
    @Persisted var itemDescription: String
    @Persisted var rating: Double
    @Persisted var isFavorited: Bool
    @Persisted var isAddedToCart: Bool
    @Persisted var price: Double
    @Persisted var thumbnails: List<String> = List()
    @Persisted var reviews: List<ReviewEntity> = List()
    
    convenience init(from dto: ItemDetails) {
        self.init()
        self.id = dto.id
        self.name = dto.name
        
        if let category = dto.category {
            self.category = CategoryEntity(from: category)
        }
        
        if let subCategory = dto.subCategory {
            self.subCategory = SubCategoryEntity(from: subCategory)
        }
        
        self.itemDescription = dto.description
        self.rating = dto.rating
        self.isFavorited = dto.isFavorited
        self.isAddedToCart = dto.isAddedToCart
        self.price = dto.price
        self.thumbnails.append(objectsIn: dto.thumbnails)
        
        if let reviews = dto.reviews {
            self.reviews
                .append(objectsIn: reviews.map { ReviewEntity(from: $0) })
        }
    }
}
