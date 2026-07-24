import RealmSwift

class CategoryEntity: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var thumbnailUrl: String?
    @Persisted var subCategories: List<SubCategoryEntity>
    
    convenience init(from dto: Category) {
        self.init()
        self.id = dto.id
        self.name = dto.name
        self.thumbnailUrl = dto.thumbnailUrl
        let entities = dto.subCategories.map { SubCategoryEntity(from: $0) }
        self.subCategories.append(objectsIn: entities)
    }
}
