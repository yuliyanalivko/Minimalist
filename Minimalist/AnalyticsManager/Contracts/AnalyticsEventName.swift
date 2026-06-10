enum AnalyticsEventName: String {
    case screenView = "screen_view"
    case viewItemList = "view_item_list"
    case viewItem = "view_item"
    case applyFilter = "apply_filter"
    case applySearch = "search"
    case addToWishlist = "add_to_wishlist"
    case removeFromWishlist = "remove_from_wishlist"
    case addToCart = "add_to_cart"
    case removeFromCart = "remove_from_cart"
    case beginCheckout = "begin_checkout"
    case purchase = "purchase"
    case remoteConfigFetchFailed = "remote_config_fetch_fail"
}
