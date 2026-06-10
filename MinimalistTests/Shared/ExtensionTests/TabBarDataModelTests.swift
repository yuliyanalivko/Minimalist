import Testing
import SwiftUI
@testable import Minimalist

@MainActor
struct TabBarDataModelTests {
    
    struct TabBarDataModelMock: TabBarDataModel {
        let items: [TabBarItemConfigurable] = [
            TabBarItem(
                title: "Favorite",
                icon: "heart",
                selectedColor: Color.orange,
                unSelectedColor: Color.blue
            )
        ]
        
        var selectedItemIndex: Int = 0
        
        func select(_ index: Int) {}
    }
    
    @Test("return true if selected index is passed")
    func isSelected_returnTrue_selectedIndexPassed() {
        var vm = TabBarDataModelMock()
        
        vm.selectedItemIndex = 1

        #expect(vm.isSelected(1))
    }
    
    @Test("return false if unselected index is passed")
    func isSelected_returnFalse_unselectedIndexPassed() {
        var vm = TabBarDataModelMock()
        
        vm.selectedItemIndex = 1

        #expect(!vm.isSelected(2))
    }
    
    @Test("return item if valid index is passed")
    func tabBarItem_returnItem_validIndex() {
        let vm = TabBarDataModelMock()

        #expect(vm.tabBarItem(at: 0)!.title == vm.items[0].title)
    }
    
    @Test("return nil if invalid index is passed")
    func tabBarItem_returnNil_invalidIndex() {
        let vm = TabBarDataModelMock()

        #expect(vm.tabBarItem(at: 10) == nil)
    }
}
