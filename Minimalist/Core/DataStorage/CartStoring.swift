protocol CartStoring {
//    TODO: Implement in the next task
//    func getCartItems() throws -> [Item]
//    func save(_ items: [Item]) throws
    func setAddedToCart(id: String, isAddedToCart: Bool) throws
}
