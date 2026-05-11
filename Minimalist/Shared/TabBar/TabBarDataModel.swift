protocol TabBarDataModel {
    var items: [TabBarItemConfigurable] { get }
    var selectedItemIndex: Int { get }
    
    func select(_ index: Int)
}

extension TabBarDataModel {
    func isSelected(_ index: Int) -> Bool {
        index == self.selectedItemIndex
    }
    
    func tabBarItem(at index: Int) -> TabBarItemConfigurable? {
        return items[safe: index]
    }
}
