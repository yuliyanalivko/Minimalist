import Testing
import SwiftUI
@testable import Minimalist

struct FilterBySheetViewModelTests {
    
    private let categories = [
        SubCategory(id: "dining", name: "Dining", thumbnailUrl: nil, iconName: nil)
    ]
    
    private func makeViewModel(
        filterState: FilterState = FilterState(),
        onApply: @escaping (FilterState) -> Void = { _ in }
    ) -> FilterBySheetViewModel {
        FilterBySheetViewModel(
            filterState: filterState,
            categories: categories,
            priceBounds: 10...100,
            onApply: onApply
        )
    }
    
    @Test("Should disable Apply when filter state is unchanged")
    func isApplyDisabled_trueWhenUnchanged() {
        let vm = makeViewModel()
        
        #expect(vm.isApplyDisabled)
    }
    
    @Test("Should enable Apply when filter state changes")
    func isApplyDisabled_falseWhenChanged() {
        let vm = makeViewModel()
        
        vm.minPrice = 20
        
        #expect(!vm.isApplyDisabled)
    }
    
    @Test("Should disable Apply when a price thumb returns to its initial position")
    func isApplyDisabled_trueWhenPriceReturnsToBounds() {
        let vm = makeViewModel()
        
        vm.minPrice = 20
        vm.minPrice = 10
        
        #expect(vm.draftFilterState.priceRange == nil)
        #expect(vm.isApplyDisabled)
    }
    
    @Test("Should fall back to the price bounds when no price filter is set")
    func price_defaultsToBounds() {
        let vm = makeViewModel()
        
        #expect(vm.minPrice == 10)
        #expect(vm.maxPrice == 100)
    }
    
    @Test("Should keep the selected price range inside the bounds")
    func price_clampedToBounds() {
        let vm = makeViewModel()
        
        vm.minPrice = 0
        vm.maxPrice = 500
        
        #expect(vm.minPrice == 10)
        #expect(vm.maxPrice == 100)
    }
    
    @Test("Should not let the lower price exceed the upper price")
    func minPrice_neverExceedsMaxPrice() {
        let vm = makeViewModel()
        
        vm.maxPrice = 50
        vm.minPrice = 80
        
        #expect(vm.minPrice == 50)
        #expect(vm.maxPrice == 50)
    }
    
    @Test("Should pass the draft state to the caller on apply")
    func apply_callsOnApplyWithDraftState() {
        var applied: FilterState?
        let vm = makeViewModel { applied = $0 }
        
        vm.minPrice = 20
        vm.draftFilterState.minRating = 3
        vm.apply()
        
        #expect(applied?.priceRange == 20...100)
        #expect(applied?.minRating == 3)
        #expect(vm.isApplyDisabled)
    }
    
    @Test("Should revert draft changes to the last applied state")
    func configureInitialState_restoreInitState() {
        let vm = makeViewModel()
        vm.minPrice = 20
        vm.draftFilterState.minRating = 3
        vm.ratingViewModel.rating = 3
        vm.expandedOptions = [.rating]
        
        vm.configureInitialState()
        
        #expect(vm.draftFilterState.priceRange == nil)
        #expect(vm.draftFilterState.minRating == 0)
        #expect(vm.ratingViewModel.rating == 0)
        #expect(vm.expandedOptions.isEmpty)
        #expect(vm.isApplyDisabled)
    }
    
    @Test("Should initialize rating from filter state")
    func init_setsRatingFromFilterState() {
        let vm = makeViewModel(filterState: FilterState(minRating: 4))
        
        #expect(vm.ratingViewModel.rating == 4)
    }
    
    @Test("Should report active filters per option")
    func hasActiveFilter_perOption() {
        let vm = makeViewModel(filterState: FilterState(categoryId: "dining", minRating: 3))
        
        #expect(vm.hasActiveFilter(option: .category))
        #expect(vm.hasActiveFilter(option: .rating))
        #expect(!vm.hasActiveFilter(option: .price))
    }
    
    @Test("Should expand and collapse an option")
    func isExpanded_togglesOption() {
        let vm = makeViewModel()
        let binding = vm.isExpanded(option: .price)
        
        binding.wrappedValue = true
        #expect(vm.expandedOptions == [.price])
        
        binding.wrappedValue = false
        #expect(vm.expandedOptions.isEmpty)
    }
    
    @Test("Should expose all filter options")
    func options_containAllCases() {
        let vm = makeViewModel()
        
        #expect(vm.options == FilterOption.allCases)
    }
    
    @Test("Should initialize min and max price from a selected range")
    func init_setsPriceFromFilterState() {
        let vm = makeViewModel(filterState: FilterState(priceRange: 20...80))
        
        #expect(vm.minPrice == 20)
        #expect(vm.maxPrice == 80)
        #expect(vm.hasActiveFilter(option: .price))
    }
    
    @Test("Should configure the rating control for editing")
    func init_configuresEditableRatingControl() {
        let vm = makeViewModel()
        
        #expect(vm.ratingViewModel.isReadOnly == false)
        #expect(vm.ratingViewModel.itemSize == 40)
        #expect(vm.ratingViewModel.itemSpacing == 24)
    }
    
    @Test("Should keep Apply disabled when only expanded sections change")
    func isApplyDisabled_trueWhenOnlyExpandedOptionsChange() {
        let vm = makeViewModel()
        
        vm.expandedOptions = [.price, .rating]
        
        #expect(vm.isApplyDisabled)
    }
    
    @Test("Should enable Apply when a category is selected")
    func isApplyDisabled_falseWhenCategoryChanges() {
        let vm = makeViewModel()
        
        vm.draftFilterState.categoryId = "dining"
        
        #expect(!vm.isApplyDisabled)
        #expect(vm.hasActiveFilter(option: .category))
    }
    
    @Test("Should pull the lower price down when the upper price is set below it")
    func maxPrice_pullsMinPriceDownWhenSetBelow() {
        let vm = makeViewModel()
        
        vm.minPrice = 50
        vm.maxPrice = 20
        
        #expect(vm.minPrice == 20)
        #expect(vm.maxPrice == 20)
        #expect(vm.draftFilterState.priceRange == 20...20)
    }
    
    @Test("Should clear the price filter when both thumbs return to the bounds")
    func isApplyDisabled_trueWhenMaxPriceReturnsToBounds() {
        let vm = makeViewModel()
        
        vm.maxPrice = 80
        vm.maxPrice = 100
        
        #expect(vm.draftFilterState.priceRange == nil)
        #expect(vm.isApplyDisabled)
    }
    
    @Test("Should restore the last applied state rather than the original empty state")
    func configureInitialState_restoresAppliedState() {
        let vm = makeViewModel()
        vm.minPrice = 20
        vm.draftFilterState.minRating = 3
        vm.ratingViewModel.rating = 3
        vm.apply()
        
        vm.minPrice = 40
        vm.draftFilterState.minRating = 5
        vm.ratingViewModel.rating = 5
        vm.expandedOptions = [.price]
        vm.configureInitialState()
        
        #expect(vm.draftFilterState.priceRange == 20...100)
        #expect(vm.draftFilterState.minRating == 3)
        #expect(vm.ratingViewModel.rating == 3)
        #expect(vm.expandedOptions.isEmpty)
        #expect(vm.isApplyDisabled)
    }
    
    @Test("Should report an active price filter from the draft state")
    func hasActiveFilter_trueForDraftPrice() {
        let vm = makeViewModel()
        
        vm.minPrice = 20
        
        #expect(vm.hasActiveFilter(option: .price))
        #expect(!vm.hasActiveFilter(option: .category))
        #expect(!vm.hasActiveFilter(option: .rating))
    }
}
