import SwiftUI

@Observable
class CartViewModel: RoutableViewModel<CartRouter> {
    let cartService: CartManaging
    var cartListViewModel: CartListViewModel
    var checkoutViewModel: CheckoutViewModel?

    init(
        router: CartRouter,
        cartService: CartManaging = CartService(),
        analyticsManager: AnalyticsManager? = nil
    ) {
        self.cartService = cartService
        cartListViewModel = CartListViewModel(router: router, cartService: cartService, analyticsManager: analyticsManager)
        super.init(router: router, analyticsManager: analyticsManager)
    }
    
    func updateCheckoutViewModel(items: [Item]) {
        guard let checkoutViewModel else {
            checkoutViewModel = CheckoutViewModel(router: router, items: items)
            
            return
        }

        if checkoutViewModel.items != items {
            checkoutViewModel.updateItems(items: items)
        }
    }
    
    func trackCartScreen() {
        logEvent(AnalyticsEvent(
            name: .screenView,
            parameters: [.screenName: CartRoute.cart.title]
        ))
    }
    
    func logCartListSearchEvent() {
        cartListViewModel.logSearchEvent()
    }
}
