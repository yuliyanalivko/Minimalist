protocol TabBarDataModel: SelectableListDataModel {
    var selectedItemIndex: Int { get }
}

extension TabBarDataModel {
    func isSelected(_ index: Int) -> Bool {
        index == self.selectedItemIndex
    }
}
