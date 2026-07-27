struct Category: CatalogItemConfigurable {
    let id: String
    let name: String
    let thumbnailUrl: String?
    let subCategories: [SubCategory]
    
    func toEntity() -> CategoryEntity {
        CategoryEntity(from: self)
    }
    
    var iconName: String? {
        switch name {
        case "Sofas":
            return "couch"
        case "Chairs":
            return "chair"
        case "Tables":
            return "table"
        case "Lamps":
            return "lamp"
        case "Beds":
            return "bed"
        case "Wardrobes":
            return "wardrobe"
        default:
            return nil
        }
    }
}

extension Category {
    init(from entity: CategoryEntity) {
        let entities = Array(entity.subCategories.map { SubCategory(from: $0) })
        
        self.init(
            id: entity.id,
            name: entity.name,
            thumbnailUrl: entity.thumbnailUrl,
            subCategories: entities
        )
    }
}
