import Testing
@testable import Minimalist

struct AnalyticsEventNameTests {
    
        @Test("Analytics event constants should match the correct raw strings",
          arguments: [
            (AnalyticsEventName.screenView, "screen_view"),
            (AnalyticsEventName.viewItemList, "view_item_list"),
            (AnalyticsEventName.viewItem, "view_item"),
            (AnalyticsEventName.applyFilter, "apply_filter"),
            (AnalyticsEventName.applySearch, "search"),
            (AnalyticsEventName.addToWishlist, "add_to_wishlist"),
            (AnalyticsEventName.removeFromWishlist, "remove_from_wishlist"),
            (AnalyticsEventName.addToCart, "add_to_cart"),
            (AnalyticsEventName.removeFromCart, "remove_from_cart"),
            (AnalyticsEventName.beginCheckout, "begin_checkout"),
            (AnalyticsEventName.purchase, "purchase"),
            (AnalyticsEventName.remoteConfigFetchFailed, "remote_config_fetch_fail")
          ]
    )
    func firebaseEventName(actualName: AnalyticsEventName, expectedName: String) {
        #expect(actualName.rawValue == expectedName)
    }
}
