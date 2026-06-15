import Testing
import Foundation
import SwiftUI
@testable import Minimalist

@Suite("RatingViewModel Tests")
struct RatingViewModelTests {
        
    @Test("initialization should configure correct default values")
    func init_defaultValues() {
        let vm = RatingViewModel()
        
        #expect(vm.rating == 0.0)
        #expect(vm.isReadOnly == true)
        #expect(vm.items.count == 5)
        #expect(vm.itemSize == 17)
        #expect(vm.items.first?.icon == "star.fill")
        #expect(vm.items.first?.highlightedColor == Color.AppColor.accent)
        #expect(vm.items.first?.inactiveColor == Color.AppColor.backgroundSecondary)
    }
    
    @Test("initialization should set correct values")
    func init_setCorrectValues() {
        let customItems = [
            SelectableListItem(icon: "heart.fill", highlightedColor: .red, inactiveColor: .gray)
        ]
        
        let vm = RatingViewModel(rating: 4.5, isReadOnly: false, items: customItems)
        
        #expect(vm.rating == 4.5)
        #expect(vm.isReadOnly == false)
        #expect(vm.items.count == 1)
        #expect(vm.items.first?.icon == "heart.fill")
        #expect(vm.items.first?.highlightedColor == .red)
        #expect(vm.items.first?.inactiveColor == .gray)
    }
    
    @Test("setRating should not update rating when view model is read-only")
    func select_ignoreRating_readonly() {
        let vm = RatingViewModel(rating: 2.0, isReadOnly: true)
        
        vm.select(3)
        
        #expect(vm.rating == 2.0)
    }
    
    @Test("setRating should update rating correctly when view model is editable")
    func select_updateRating_notReadonly() {
        let vm = RatingViewModel(rating: 2.0, isReadOnly: false)
        
        vm.select(3)
        
        #expect(vm.rating == 4.0)
    }
        
    @Test("itemFill should calculate accurate fractional fill values across", arguments: [
        (index: 0, expected: 1.0),
        (index: 1, expected: 1.0),
        (index: 2, expected: 1.0),
        (index: 3, expected: 0.5),
        (index: 4, expected: 0.0)
    ])
    func itemFill_calculateFillValue(index: Int, expected: Double) {
        let vm = RatingViewModel(rating: 3.5)
        
        #expect(vm.itemFill(index) == expected)
    }
    
    @Test("maskWidth should calculate the width of the item mask")
    func maskWidth_() {
        let vm = RatingViewModel() // Default size = 17
        
        #expect(vm.maskWidth(itemFill: 1.0) == nil)
        #expect(vm.maskWidth(itemFill: 0.5) == 8.5)
        #expect(vm.maskWidth(itemFill: 0.0) == 0.0)
    }
}
