import RealmSwift

class SubCategoryEntity: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var thumbnailUrl: String?
    @Persisted var iconName: String?
    
    convenience init(from dto: SubCategory) {
        self.init()
        self.id = dto.id
        self.name = dto.name
        self.thumbnailUrl = dto.thumbnailUrl
        self.iconName = dto.iconName
    }
}
