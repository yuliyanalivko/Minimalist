import RealmSwift

class ItemEntity: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var category: CategoryEntity?
    @Persisted var subcategory: SubCategoryEntity?
    @Persisted var rating: Double
    @Persisted var isFavorited: Bool
    @Persisted var isAddedToCart: Bool
    @Persisted var price: Double
    @Persisted var thumbnailUrl: String?
    
    convenience init(from dto: Item) {
        self.init()
        self.id = dto.id
        self.name = dto.name
        
        if let category = dto.category {
            self.category = CategoryEntity(from: category)
        }
        
        if let subcategory = dto.subcategory {
            self.subcategory = SubCategoryEntity(from: subcategory)
        }
        
        self.rating = dto.rating
        self.isFavorited = dto.isFavorited
        self.isAddedToCart = dto.isAddedToCart
        self.price = dto.price
        self.thumbnailUrl = dto.thumbnailUrl
    }
}
