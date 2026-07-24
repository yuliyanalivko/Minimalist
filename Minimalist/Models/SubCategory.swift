struct SubCategory: CatalogItemConfigurable {
    let id: String
    let name: String
    let thumbnailUrl: String?
    let iconName: String?
    
    func toEntity() -> SubCategoryEntity {
        SubCategoryEntity(from: self)
    }
}

extension SubCategory {
    init(from entity: SubCategoryEntity) {
        self.init(
            id: entity.id,
            name: entity.name,
            thumbnailUrl: entity.thumbnailUrl,
            iconName: entity.iconName
        )
    }
}
