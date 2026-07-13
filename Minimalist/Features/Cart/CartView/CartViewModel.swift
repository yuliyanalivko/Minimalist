import SwiftUI

@Observable
class CartViewModel: RoutableViewModel<CartRouter> {
    
    init(router: CartRouter) {
        super.init(router: router)
    }
}
