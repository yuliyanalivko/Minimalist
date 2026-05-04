import SwiftUI

@Observable
class FlatTabViewModel: BaseViewModel {
    enum TabError: Error {
        case emptyTabs
    }
    
    let tabs: [TabItem]
    
    var selectedTabIndex: Int = 0 {
        didSet {
            let validIndex = Self.validSelectedTabIndex(selectedTabIndex, tabsCount: tabs.count)
            
            if selectedTabIndex != validIndex {
                selectedTabIndex = validIndex
            }
        }
    }
    
    var selectedTab: TabItem {
        tabs[selectedTabIndex]
    }
    
    init?(tabs: [TabItem], selectedTabIndex: Int = 0) {
        guard !tabs.isEmpty else {
            return nil
        }
        
        self.tabs = tabs
        self.selectedTabIndex = Self.validSelectedTabIndex(selectedTabIndex, tabsCount: tabs.count)
    }
    
    func isSelected(_ index: Int) -> Bool {
        selectedTabIndex == index
    }
    
    private static func validSelectedTabIndex(_ index: Int, tabsCount: Int) -> Int {
        max(0, min(index, tabsCount - 1))
    }
}
