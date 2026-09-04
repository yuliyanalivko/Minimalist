import Testing
import SwiftUI
@testable import Minimalist

struct SortBySheetViewModelTests {
    
    @Test("Should select option and order when order is provided")
    func updateSelection_setOptionAndOrder() {
        let vm = SortBySheetViewModel()
        
        vm.updateSelection(order: .forward, option: .price)
        
        #expect(vm.selectedOption == .price)
        #expect(vm.selectedOrder == .forward)
    }
    
    @Test("Should clear selection when order is nil")
    func updateSelection_clearSelection_whenOrderIsNil() {
        let vm = SortBySheetViewModel()
        
        vm.updateSelection(order: .reverse, option: .name)
        vm.updateSelection(order: nil, option: .name)
        
        #expect(vm.selectedOption == nil)
        #expect(vm.selectedOrder == nil)
    }
    
    @Test("Should replace previous selection when a different option is chosen")
    func updateSelection_replacePreviousOption() {
        let vm = SortBySheetViewModel()
        
        vm.updateSelection(order: .forward, option: .name)
        vm.updateSelection(order: .reverse, option: .rating)
        
        #expect(vm.selectedOption == .rating)
        #expect(vm.selectedOrder == .reverse)
        #expect(vm.selectedOrder(for: .name) == nil)
        #expect(vm.selectedOrder(for: .rating) == .reverse)
    }
    
    @Test("Should return selected order only for the active option")
    func getSelectedOrder_returnOrderForSelectedOptionOnly() {
        let vm = SortBySheetViewModel()
        
        vm.updateSelection(order: .forward, option: .price)
        
        #expect(vm.selectedOrder(for: .price) == .forward)
        #expect(vm.selectedOrder(for: .name) == nil)
        #expect(vm.selectedOrder(for: .rating) == nil)
    }
    
    @Test("Should expose all sort options")
    func options_containAllCases() {
        let vm = SortBySheetViewModel()
        
        #expect(vm.options == SortOption.allCases)
    }
}
