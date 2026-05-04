import Testing
@testable import Minimalist

@MainActor
struct FlatTabViewModelTests {
    let tabs: [TabItem] = [
        TabItem(
            title: "Home",
            icon: "house"
        ),
        TabItem(
            title: "Cart",
            icon: "cart"
        ),
        TabItem(
            title: "Settings",
            icon: "gearshape"
        )
    ]
    
    @Test("should set initial tab as selected")
    func init_setSelectedTab() {
        let vm = FlatTabViewModel(tabs: tabs, selectedTab: tabs[1])

        #expect(vm.selectedTab == tabs[1])
    }
    
    @Test("should set first tab as selected when initial tab is nil")
    func init_selectsFirstTab() {
        let vm = FlatTabViewModel(tabs: tabs)

        #expect(vm.selectedTab == tabs[0])
    }
    
    @Test("should set first tab as selected if initial tab is not in tabs")
    func init_invalidSelectedTab() {
        let vm = FlatTabViewModel(tabs: tabs, selectedTab: TabItem(title: "Favorites", icon: "heart"))

        #expect(vm.selectedTab == tabs[0])
    }
    
    @Test("should set given selected tab")
    func select_setSelectedTab() {
        let vm = FlatTabViewModel(tabs: tabs)
        
        vm.select(tabs[1])

        #expect(vm.selectedTab == tabs[1])
    }
    
    @Test("should set first tab as selected if given tab is not in tabs")
    func select_selectsFirstTab() {
        let vm = FlatTabViewModel(tabs: tabs)
        
        vm.select(TabItem(title: "Favorites", icon: "heart"))

        #expect(vm.selectedTab == tabs[0])
    }
    
    @Test("should return true for selected tab")
    func isSelected_selectedTab() {
        let vm = FlatTabViewModel(tabs: tabs)

        #expect(vm.isSelected(tabs[0]))
    }
    
    @Test("should return false for unselected tab")
    func isSelected_unselectedTab() {
        let vm = FlatTabViewModel(tabs: tabs)

        #expect(!vm.isSelected(tabs[1]))
    }
}
