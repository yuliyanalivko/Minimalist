protocol CatalogStoring {
    func getCategories() throws -> [Category]
    func save(_ categories: [Category]) throws
    
    func getItems() throws -> [Item]
    func save(_ items: [Item]) throws
    
    func getItemDetails(id: String) throws -> ItemDetails?
    func save(_ itemDetails: ItemDetails) throws    
}
