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
        #expect(vm.itemSpacing == 4)
        #expect(vm.onChange == nil)
        #expect(vm.items.first?.icon == "star.fill")
        #expect(vm.items.first?.highlightedColor == Color.AppColor.accent)
        #expect(vm.items.first?.inactiveColor == Color.AppColor.backgroundSecondary)
    }
    
    @Test("initialization should set correct values")
    func init_setCorrectValues() {
        let customItems = [
            SelectableListItem(icon: "heart.fill", highlightedColor: .red, inactiveColor: .gray)
        ]
        
        let vm = RatingViewModel(
            rating: 4.5,
            isReadOnly: false,
            items: customItems,
            itemSize: 40,
            itemSpacing: 24
        )
        
        #expect(vm.rating == 4.5)
        #expect(vm.isReadOnly == false)
        #expect(vm.items.count == 1)
        #expect(vm.itemSize == 40)
        #expect(vm.itemSpacing == 24)
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
    
    @Test("select should clear the rating when the same star is tapped again")
    func select_clearRating_whenSameStarTapped() {
        let vm = RatingViewModel(rating: 4.0, isReadOnly: false)
        
        vm.select(3)
        
        #expect(vm.rating == 0)
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
    
    @Test("updateRating should set rating from the drag position")
    func updateRating_setsRatingFromPosition() {
        let vm = RatingViewModel(isReadOnly: false)
        
        vm.updateRating(for: 22)
        
        #expect(vm.rating == 2)
    }
    
    @Test("updateRating should ignore drags when the view model is read-only")
    func updateRating_ignoreWhenReadOnly() {
        let vm = RatingViewModel(rating: 2.0, isReadOnly: true)
        
        vm.updateRating(for: 80)
        
        #expect(vm.rating == 2.0)
    }
    
    @Test("notifyChange should call onChange with the current rating")
    func notifyChange_callsOnChange() {
        var received: Double?
        let vm = RatingViewModel(rating: 3, isReadOnly: false) { received = $0 }
        
        vm.notifyChange()
        
        #expect(received == 3)
    }
    
    @Test("notifyChange should ignore changes when the view model is read-only")
    func notifyChange_ignoreWhenReadOnly() {
        var received: Double?
        let vm = RatingViewModel(rating: 3, isReadOnly: true, onChange: { received = $0 })
        
        vm.notifyChange()
        
        #expect(received == nil)
    }
    
    @Test("rating(for:) should reset when dragged past the leading edge")
    func ratingFor_resetWhenPastLeadingEdge() {
        let vm = RatingViewModel()
        
        #expect(vm.rating(for: -11) == 0)
    }
    
    @Test("rating(for:) should clamp to the number of stars")
    func ratingFor_clampedToItemCount() {
        let vm = RatingViewModel()
        
        #expect(vm.rating(for: 0) == 1)
        #expect(vm.rating(for: 22) == 2)
        #expect(vm.rating(for: 1000) == 5)
    }
}
