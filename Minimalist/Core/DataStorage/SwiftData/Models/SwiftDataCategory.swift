import SwiftData
import Foundation

@Model
final class SwiftDataCategory: Persistable, EntityIdentified, Expirable {
    @Attribute(.unique)
    var entityId: String
    
    var name: String
    var thumbnailUrl: String?
    var subCategories: [SubCategory] = []
    var cachedAt: Date
    
    init(
        entityId: String,
        name: String,
        thumbnailUrl: String?,
        subCategories: [SubCategory] = []
    ) {
        self.entityId = entityId
        self.name = name
        self.thumbnailUrl = thumbnailUrl
        self.subCategories = subCategories
        self.cachedAt = Date()
    }
    
    convenience init(from dto: Category) {
        self.init(
            entityId: dto.id,
            name: dto.name,
            thumbnailUrl: dto.thumbnailUrl,
            subCategories: dto.subCategories
        )
    }
}
