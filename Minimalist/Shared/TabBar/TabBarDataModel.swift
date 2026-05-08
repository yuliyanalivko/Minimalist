protocol TabBarDataModel {
    var items: [TabBarItemConfigurable] { get }
    var selectedItemIndex: Int { get }
    
    func select(_ index: Int)
}

extension TabBarDataModel {
    func validSelectedItemIndex(_ index: Int) -> Int {
        max(0, min(index, self.items.count - 1))
    }
    
    func isSelected(_ index: Int) -> Bool {
        index == self.selectedItemIndex
    }
}
