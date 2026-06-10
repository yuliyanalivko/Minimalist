import Testing
@testable import Minimalist

struct AnalyticsParamNameTests {
    
        @Test("Analytics event constants should match the correct raw strings",
          arguments: [
            (AnalyticsParamName.screenName, "screen_name"),
            (AnalyticsParamName.itemId, "item_id"),
            (AnalyticsParamName.itemName, "item_name"),
            (AnalyticsParamName.listId, "list_id"),
            (AnalyticsParamName.listName, "list_name"),
            (AnalyticsParamName.categoryName, "category"),
            (AnalyticsParamName.subCategoryName, "subcategory"),
            (AnalyticsParamName.searchTerm, "search_term"),
            (AnalyticsParamName.quantity, "quantity"),
            (AnalyticsParamName.errorMessage, "error_message"),
            (AnalyticsParamName.items, "items"),
            (AnalyticsParamName.filterCategory, "filter_category"),
            (AnalyticsParamName.filterPrice, "filter_price"),
            (AnalyticsParamName.filterRating, "filter_rating")
          ]
    )
    func analyticsEventParameter(actualName: AnalyticsParamName, expectedName: String) {
        #expect(actualName.rawValue == expectedName)
    }
}
