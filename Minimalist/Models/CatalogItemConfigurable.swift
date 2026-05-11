protocol CatalogItemConfigurable: Identifiable, Codable, Equatable {
    var id: String { get }
    var name: String { get }
    var thumbnailUrl: String? { get }
    var iconName: String? { get }
}
