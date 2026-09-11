import SwiftUI

@Observable
class CartViewModel: RoutableViewModel<CartRouter> {
    var cartListViewModel: CartListViewModel

    override init(router: CartRouter, analyticsManager: AnalyticsManager? = nil) {
        cartListViewModel = CartListViewModel(router: router)
        super.init(router: router, analyticsManager: analyticsManager)
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
