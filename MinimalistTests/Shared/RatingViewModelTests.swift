import Testing
import Foundation
import SwiftUI
@testable import Minimalist

@Suite("RatingViewModel Tests")
struct RatingViewModelTests {
        
    @Test("initialization should configure correct default values")
    func init_defaultValues() {
        let sut = RatingViewModel()
        
        #expect(sut.rating == 0.0)
        #expect(sut.isReadOnly == true)
        #expect(sut.ratingItems.count == 5)
        #expect(sut.itemSize == 17)
        #expect(sut.spacing == 4)
        #expect(sut.ratingItems.first?.icon == "star.fill")
        #expect(sut.ratingItems.first?.highlightedColor == Color.AppColor.accent)
        #expect(sut.ratingItems.first?.backgroundColor == Color.AppColor.backgroundSecondary)
    }
    
    @Test("initialization should set correct values")
    func init_setCorrectValues() {
        let customItems = [
            RatingItem(icon: "heart.fill", highlightedColor: .red, backgroundColor: .gray)
        ]
        
        let vm = RatingViewModel(rating: 4.5, isReadOnly: false, ratingItems: customItems)
        
        #expect(vm.rating == 4.5)
        #expect(vm.isReadOnly == false)
        #expect(vm.ratingItems.count == 1)
        #expect(vm.ratingItems.first?.icon == "heart.fill")
        #expect(vm.ratingItems.first?.highlightedColor == .red)
        #expect(vm.ratingItems.first?.backgroundColor == .gray)
    }
    
    @Test("setRating should not update rating when view model is read-only")
    func setRating_ignoreRating_readonly() {
        let vm = RatingViewModel(rating: 2.0, isReadOnly: true)
        
        vm.setRating(3)
        
        #expect(vm.rating == 2.0)
    }
    
    @Test("setRating should update rating correctly when view model is editable")
    func setRating_updateRating_notReadonly() {
        let vm = RatingViewModel(rating: 2.0, isReadOnly: false)
        
        vm.setRating(3)
        
        #expect(vm.rating == 4.0)
    }
        
    @Test("starFill should calculate accurate fractional fill values across", arguments: [
        (index: 0, expected: 1.0),
        (index: 1, expected: 1.0),
        (index: 2, expected: 1.0),
        (index: 3, expected: 0.5),
        (index: 4, expected: 0.0)
    ])
    func starFill_calculateFillValue(index: Int, expected: Double) {
        let vm = RatingViewModel(rating: 3.5)
        
        #expect(vm.starFill(index) == expected)
    }
    
    @Test("maskWidth should calculate the width of the item mask")
    func maskWidth_() {
        let vm = RatingViewModel() // Default size = 17, spacing = 4
        
        #expect(vm.maskWidth(starFill: 1.0) == nil)
        #expect(vm.maskWidth(starFill: 0.5) == 10.5)
        #expect(vm.maskWidth(starFill: 0.0) == 0.0)
    }
}
