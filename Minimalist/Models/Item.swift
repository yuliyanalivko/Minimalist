struct Item: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let category: Category
    let subcategory: SubCategory?
    let rating: Double
    var isFavorited: Bool
    var isAddedToCart: Bool
    let price: Double
    var thumbnailUrl: String?
}
