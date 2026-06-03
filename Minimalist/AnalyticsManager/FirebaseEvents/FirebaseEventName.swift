import FirebaseAnalytics

enum FirebaseEventName {
    static let viewItemList: String = AnalyticsEventViewItemList
    static let viewItem: String = AnalyticsEventViewItem
    static let applyFilter: String = "apply_filter"
    static let applySearch: String = AnalyticsEventSearch
    static let addToWishlist: String = AnalyticsEventAddToWishlist
    static let removeFromWishlist: String = "remove_from_wishlist"
    static let addToCart: String = AnalyticsEventAddToCart
    static let removeFromCart: String = AnalyticsEventRemoveFromCart
    static let beginCheckout: String = AnalyticsEventBeginCheckout
    static let purchase: String = AnalyticsEventPurchase
    static let remoteConfigFetchFailed: String = "remote_config_fetch_fail"
}
