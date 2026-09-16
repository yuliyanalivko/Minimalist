protocol CartStoring {
    func getCartItems() throws -> [Item]
    func save(_ items: [Item]) throws
    func setAddedToCart(id: String, isAddedToCart: Bool) throws
}
