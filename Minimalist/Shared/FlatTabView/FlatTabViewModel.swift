import SwiftUI

@Observable
class FlatTabViewModel {
    enum TabError: Error {
        case emptyTabs
    }
    
    let tabs: [TabItem]
    
    var selectedTab: TabItem
    
    init(tabs: [TabItem], selectedTab: TabItem? = nil) {
        assert(!tabs.isEmpty, "Tabs cannot be empty")

        self.tabs = tabs
        self.selectedTab = tabs.first(where: { $0.id == selectedTab?.id }) ?? tabs.first!
    }
    
    func select(_ tab: TabItem) {
        selectedTab = tabs.first(where: { $0.id == tab.id }) ?? tabs.first!
    }
    
    func isSelected(_ tab: TabItem) -> Bool {
        selectedTab.id == tab.id
    }
}
