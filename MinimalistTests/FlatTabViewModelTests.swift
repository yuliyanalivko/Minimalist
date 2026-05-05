import SwiftUI
import Testing
@testable import Minimalist

@MainActor
struct FlatTabViewModelTests {
    let tabs: [TabItem] = [
        TabItem(
            title: "Home",
            icon: "house",
            view: AnyView(Text("Home"))
        ),
        TabItem(
            title: "Cart",
            icon: "cart",
            view: AnyView(Text("Cart"))
        ),
        TabItem(
            title: "Settings",
            icon: "gearshape",
            view: AnyView(Text("Settings"))
        )
    ]
    
    @Test("sets selectedTabIndex when valid index is provided")
    func init_setSelectedTabIndex() {
        let vm = FlatTabViewModel(tabs: tabs, selectedTabIndex: 1)!

        #expect(vm.selectedTabIndex == 1)
    }
    
    @Test("sets selectedTabIndex to 0 when index is negative")
    func init_setSelectedTabIndex_negative() {
        let vm = FlatTabViewModel(tabs: tabs, selectedTabIndex: -10)!

        #expect(vm.selectedTabIndex == 0)
    }
    
    @Test("sets selectedTabIndex to last index when index is too large")
    func init_setSelectedTabIndex_tooLarge() {
        let vm = FlatTabViewModel(tabs: tabs, selectedTabIndex: 10)!

        #expect(vm.selectedTabIndex == 2)
    }
    
    @Test("updates selectedTabIndex when valid index is set")
    func selectedTabIndex_updatesValue() {
        let vm = FlatTabViewModel(tabs: tabs)!
        
        vm.selectedTabIndex = 1

        #expect(vm.selectedTabIndex == 1)
    }
    
    @Test("update selectedTabIndex to 0 when negative value is assigned")
    func selectedTabIndex_setToFirstIndex_negative() {
        let vm = FlatTabViewModel(tabs: tabs)!
        
        vm.selectedTabIndex = -10

        #expect(vm.selectedTabIndex == 0)
    }
    
    @Test("update selectedTabIndex to last index when value is too large")
    func selectedTabIndex_setToLastIndex_tooLarge() {
        let vm = FlatTabViewModel(tabs: tabs)!
     
        vm.selectedTabIndex = 10

        #expect(vm.selectedTabIndex == 2)
    }
  
    @Test("should return true for selected tab")
    func isSelected_selectedIndex_returnTrue() {
        let vm = FlatTabViewModel(tabs: tabs)!

        #expect(vm.isSelected(0))
    }
    
    @Test("should return false for unselected tab")
    func isSelected_nonSelectedIndex_returnFalse() {
        let vm = FlatTabViewModel(tabs: tabs)!

        #expect(!vm.isSelected(1))
    }
}
