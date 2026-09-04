struct FilterState: Equatable {
    var categoryId: String?
    var priceRange: ClosedRange<Double>?
    var minRating: Double
    
    var isEmpty: Bool {
        categoryId == nil && priceRange == nil && minRating == 0
    }
    
    init(
        categoryId: String? = nil,
        priceRange: ClosedRange<Double>? = nil,
        minRating: Double = 0
    ) {
        self.categoryId = categoryId
        self.priceRange = priceRange
        self.minRating = minRating
    }
}
