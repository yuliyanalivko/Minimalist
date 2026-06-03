import Testing
@testable import Minimalist
import FirebaseAnalytics

struct FirebaseEventNameTests {
    
        @Test("Firebase event constants should match the correct raw strings",
          arguments: [
            (FirebaseEventName.viewItemList, "view_item_list"),
            (FirebaseEventName.viewItem, "view_item"),
            (FirebaseEventName.applyFilter, "apply_filter"),
            (FirebaseEventName.applySearch, "search"),
            (FirebaseEventName.addToWishlist, "add_to_wishlist"),
            (FirebaseEventName.removeFromWishlist, "remove_from_wishlist"),
            (FirebaseEventName.addToCart, "add_to_cart"),
            (FirebaseEventName.removeFromCart, "remove_from_cart"),
            (FirebaseEventName.beginCheckout, "begin_checkout"),
            (FirebaseEventName.purchase, "purchase"),
            (FirebaseEventName.remoteConfigFetchFailed, "remote_config_fetch_fail")
          ]
    )
    func firebaseEventName(actualName: String, expectedName: String) {
        #expect(actualName == expectedName)
    }
}
