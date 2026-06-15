protocol SelectableListDataModel {
    var items: [SelectableListItemRepresentable] { get }
    
    func select(_ index: Int)
}

extension SelectableListDataModel {
    func item(at index: Int) -> SelectableListItemRepresentable? {
        items[safe: index]
    }
}
