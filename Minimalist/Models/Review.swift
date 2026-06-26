struct Review: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let rating: Int
    let message: String?
}
