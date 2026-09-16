import SwiftUI

@Observable
class CartViewModel: RoutableViewModel<CartRouter> {
    var cartListViewModel: CartListViewModel
    var checkoutViewModel: CheckoutViewModel?

    override init(router: CartRouter, analyticsManager: AnalyticsManager? = nil) {
        cartListViewModel = CartListViewModel(router: router)
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
