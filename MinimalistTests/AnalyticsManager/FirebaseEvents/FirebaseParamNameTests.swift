import Testing
@testable import Minimalist
import FirebaseAnalytics

struct FirebaseParamNameTests {
    
        @Test("Firebase event constants should match the correct raw strings",
          arguments: [
            (FirebaseParamName.itemId, AnalyticsParameterItemID),
            (FirebaseParamName.itemName, AnalyticsParameterItemName),
            (FirebaseParamName.listId, AnalyticsParameterItemListID),
            (FirebaseParamName.listName, AnalyticsParameterItemListName),
            (FirebaseParamName.categoryName, AnalyticsParameterItemCategory),
            (FirebaseParamName.subCategoryName, AnalyticsParameterItemCategory2),
            (FirebaseParamName.searchTerm, AnalyticsParameterSearchTerm),
            (FirebaseParamName.quantity, AnalyticsParameterQuantity),
            (FirebaseParamName.errorMessage, "error_message"),
            (FirebaseParamName.items, AnalyticsParameterItems),
            (FirebaseParamName.filterCategory, "filter_category"),
            (FirebaseParamName.filterPrice, "filter_price"),
            (FirebaseParamName.filterRating, "filter_rating")
          ]
    )
    func firebaseEventParameter(actualName: String, expectedName: String) {
        #expect(actualName == expectedName)
    }
}
