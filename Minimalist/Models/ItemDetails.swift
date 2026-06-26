struct ItemDetails: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let category: Category
    let subCategory: SubCategory?
    let description: String
    let rating: Double
    var isFavorited: Bool
    var isAddedToCart: Bool
    let price: Double
    var thumbnails: [String]
    let reviews: [Review]?
}
