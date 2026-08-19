struct Category: CatalogItemConfigurable {
    let id: String
    let name: String
    let thumbnailUrl: String?
    let subCategories: [SubCategory]
    
    func toRealm() -> RealmCategory {
        RealmCategory(from: self)
    }
    
    func toSwiftData() -> SwiftDataCategory {
        SwiftDataCategory(from: self)
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
    init(from entity: RealmCategory) {
        let entities = Array(entity.subCategories.map { SubCategory(from: $0) })
        
        self.init(
            id: entity.id,
            name: entity.name,
            thumbnailUrl: entity.thumbnailUrl,
            subCategories: entities
        )
    }
    
    init(from entity: SwiftDataCategory) {
        self.init(
            id: entity.entityId,
            name: entity.name,
            thumbnailUrl: entity.thumbnailUrl,
            subCategories: entity.subCategories
        )
    }
}

