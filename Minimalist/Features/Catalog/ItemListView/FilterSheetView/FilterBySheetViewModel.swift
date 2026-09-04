import SwiftUI

@Observable
class FilterBySheetViewModel {
    var categories: [SubCategory]
    var priceBounds: ClosedRange<Double>
    
    let options = FilterOption.allCases
    var expandedOptions: Set<FilterOption> = []
    
    var draftFilterState: FilterState
    var appliedFilterState: FilterState
    
    let ratingViewModel: RatingViewModel
    
    var isApplyDisabled: Bool {
        draftFilterState == appliedFilterState
    }
    
    var minPrice: Double {
        get {
            draftFilterState.priceRange?.lowerBound ?? priceBounds.lowerBound
        }
        set {
            updatePriceRange(lowerBound: newValue, upperBound: maxPrice)
        }
    }
    
    var maxPrice: Double {
        get {
            draftFilterState.priceRange?.upperBound ?? priceBounds.upperBound
        }
        set {
            updatePriceRange(lowerBound: minPrice, upperBound: newValue)
        }
    }
    
    private let onApply: (FilterState) -> Void
    
    init(
        filterState: FilterState = FilterState(),
        categories: [SubCategory],
        priceBounds: ClosedRange<Double>,
        onApply: @escaping (FilterState) -> Void = { _ in }
    ) {
        self.draftFilterState = filterState
        self.appliedFilterState = filterState
        self.categories = categories
        self.priceBounds = priceBounds
        self.onApply = onApply
        
        ratingViewModel = RatingViewModel(
            rating: filterState.minRating,
            isReadOnly: false,
            itemSize: 40,
            itemSpacing: 24
        )
    }
    
    func apply() {
        appliedFilterState = draftFilterState
        onApply(draftFilterState)
    }
    
    func configureInitialState() {
        draftFilterState = appliedFilterState
        ratingViewModel.rating = appliedFilterState.minRating
        expandedOptions = []
    }
    
    func hasActiveFilter(option: FilterOption) -> Bool {
        switch option {
        case .category:
            draftFilterState.categoryId != nil
        case .price:
            draftFilterState.priceRange != nil
        case .rating:
            draftFilterState.minRating > 0
        }
    }
    
    func isExpanded(option: FilterOption) -> Binding<Bool> {
        Binding(
            get: { self.expandedOptions.contains(option) },
            set: { isExpanded in
                if isExpanded {
                    self.expandedOptions.insert(option)
                } else {
                    self.expandedOptions.remove(option)
                }
            }
        )
    }
    
    func clear() {
        draftFilterState = FilterState()
        ratingViewModel.rating = 0
    }
    
    private func updatePriceRange(lowerBound: Double, upperBound: Double) {
        let upperBound = min(max(upperBound, priceBounds.lowerBound), priceBounds.upperBound)
        let lowerBound = min(max(lowerBound, priceBounds.lowerBound), upperBound)
        let range = lowerBound...upperBound
        
        draftFilterState.priceRange = range == priceBounds ? nil : range
    }
}
