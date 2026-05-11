import Testing
import SwiftUI
@testable import Minimalist

@MainActor
struct MainTabViewModelTests {
    @Test("updates selectedItemIndex")
    func select_updateSelectedItemIndex() {
        let vm = MainTabViewModel()
        
        vm.select(1)

        #expect(vm.selectedItemIndex == 1)
    }
    
    @Test("updates selectedItemIndex to 0 when negative value is passed")
    func selectedItemIndex_setToFirstIndex_negative() {
        let vm = MainTabViewModel()
        
        vm.select(-10)

        #expect(vm.selectedItemIndex == 0)
    }
    
    @Test("updates selectedItemIndex to last index when passed value is too large")
    func selectedItemIndex_setToLastIndex_tooLarge() {
        let vm = MainTabViewModel()
     
        vm.select(10)

        #expect(vm.selectedItemIndex == vm.items.count - 1)
    }
  
    @Test("should return true for selected tab")
    func isSelected_selectedIndex_returnTrue() {
        let vm = MainTabViewModel()

        #expect(vm.isSelected(0))
    }
    
    @Test("should return false for unselected tab")
    func isSelected_nonSelectedIndex_returnFalse() {
        let vm = MainTabViewModel()

        #expect(!vm.isSelected(1))
    }
}
