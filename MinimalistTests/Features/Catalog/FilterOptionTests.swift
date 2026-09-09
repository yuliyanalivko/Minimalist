import Testing
@testable import Minimalist

struct FilterOptionTests {
    
    @Test("Should expose all filter options")
    func allCases_containEveryOption() {
        #expect(FilterOption.allCases == [.category, .price, .rating])
    }
    
    @Test("Should use display titles as raw values", arguments: [
        (FilterOption.category, "Category"),
        (FilterOption.price, "Price"),
        (FilterOption.rating, "Rating")
    ])
    func rawValue_matchesDisplayTitle(option: FilterOption, expected: String) {
        #expect(option.rawValue == expected)
    }
}
