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
  
    @Test("should return selected item")
    func selectedItem_returnSelectedItem_validIndex() {
        let vm = MainTabViewModel()

        #expect(vm.selectedItem?.title == vm.items[0].title)
    }
    
    @Test("should return nil if index is invalid")
    func selectedItem_returnNil_invalidIndex() {
        let vm = MainTabViewModel()
        
        vm.select(-10)

        #expect(vm.selectedItem == nil)
    }
    
    @Test("Should set cart badge text")
    func cartBadge_hiddenWhenEmpty() {
        let vm = MainTabViewModel()
        let cartIndex = MainTabViewModel.Tab.allCases.firstIndex(of: .cart)
        
        #expect(cartIndex != nil)
        #expect(vm.items[cartIndex!].badgeText == "0")
    }
    
    @Test("Should schedule a notification when the cart is not empty")
    func scheduleNotification_setNotificationId_whenCartIsNotEmpty() {
        let vm = MainTabViewModel(cartService: MockCartManager(items: [item]))
        
        vm.scheduleNotification()
        
        #expect(vm.notificationId != nil)
    }
    
    @Test("Should not schedule a notification when the cart is empty")
    func scheduleNotification_doesNothing_whenCartIsEmpty() {
        let vm = MainTabViewModel()
        
        vm.scheduleNotification()
        
        #expect(vm.notificationId == nil)
    }
    
    @Test("Should not cancel when no notification was scheduled")
    func cancelNotification_doesNothing_whenIdIsNil() {
        let vm = MainTabViewModel()
        
        vm.cancelNotification()
        
        #expect(vm.notificationId == nil)
    }
}
