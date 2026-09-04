import Testing
@testable import Minimalist

struct FilterStateTests {
    
    @Test("Should be empty when no filters are set")
    func isEmpty_trueWhenDefault() {
        #expect(FilterState().isEmpty)
    }
    
    @Test("Should not be empty when a category is selected")
    func isEmpty_falseWhenCategorySet() {
        #expect(!FilterState(categoryId: "dining").isEmpty)
    }
    
    @Test("Should not be empty when a price range is selected")
    func isEmpty_falseWhenPriceRangeSet() {
        #expect(!FilterState(priceRange: 10...50).isEmpty)
    }
    
    @Test("Should not be empty when a minimum rating is selected")
    func isEmpty_falseWhenMinRatingSet() {
        #expect(!FilterState(minRating: 3).isEmpty)
    }
    
    @Test("Should compare equal when all fields match")
    func equatable_equalWhenFieldsMatch() {
        let lhs = FilterState(categoryId: "dining", priceRange: 10...50, minRating: 3)
        let rhs = FilterState(categoryId: "dining", priceRange: 10...50, minRating: 3)
        
        #expect(lhs == rhs)
    }
    
    @Test("Should compare unequal when any field differs")
    func equatable_unequalWhenFieldsDiffer() {
        let base = FilterState(categoryId: "dining", priceRange: 10...50, minRating: 3)
        
        #expect(base != FilterState(categoryId: "lighting", priceRange: 10...50, minRating: 3))
        #expect(base != FilterState(categoryId: "dining", priceRange: 10...80, minRating: 3))
        #expect(base != FilterState(categoryId: "dining", priceRange: 10...50, minRating: 4))
        #expect(base != FilterState())
    }
}
