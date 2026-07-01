import Testing
import SwiftUI
@testable import Minimalist

@MainActor
struct MainTabViewModelTests {
    
    func makeViewModel() -> MainTabViewModel {
        try? ServiceLocator.shared.unregister(CategoryProviding.self)
        try! ServiceLocator.shared.register(service: StubCategoryProviding() as CategoryProviding)
        
        return MainTabViewModel()
    }
    @Test("updates selectedItemIndex")
    func select_updateSelectedItemIndex() {
        let vm = makeViewModel()
        
        vm.select(1)

        #expect(vm.selectedItemIndex == 1)
    }
  
    @Test("should return selected item")
    func selectedItem_returnSelectedItem_validIndex() {
        let vm = makeViewModel()

        #expect(vm.selectedItem?.title == vm.items[0].title)
    }
    
    @Test("should return nil if index is invalid")
    func selectedItem_returnNil_invalidIndex() {
        let vm = makeViewModel()
        
        vm.select(-10)

        #expect(vm.selectedItem == nil)
    }
}
