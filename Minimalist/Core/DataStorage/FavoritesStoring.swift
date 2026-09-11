protocol FavoritesStoring {
    func getFavorites() throws -> [Item]
    func save(_ items: [Item]) throws
    func setFavorited(id: String, isFavorited: Bool) throws
}
