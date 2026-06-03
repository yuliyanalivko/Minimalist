import FirebaseAnalytics

enum FirebaseParamName {
    static let itemId: String = AnalyticsParameterItemID
    static let itemName: String = AnalyticsParameterItemName
    static let listId: String = AnalyticsParameterItemListID
    static let listName: String = AnalyticsParameterItemListName
    static let categoryName: String = AnalyticsParameterItemCategory
    static let subCategoryName: String = AnalyticsParameterItemCategory2
    static let searchTerm: String = AnalyticsParameterSearchTerm
    static let quantity: String = AnalyticsParameterQuantity
    static let errorMessage: String = "error_message"
    static let items: String = AnalyticsParameterItems
    static let filterCategory: String = "filter_category"
    static let filterPrice: String = "filter_price"
    static let filterRating: String = "filter_rating"
}
