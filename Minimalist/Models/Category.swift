struct Category: CatalogItemConfigurable {
    let id: String
    let name: String
    let thumbnailUrl: String?
    let subCategories: [SubCategory]
    
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
