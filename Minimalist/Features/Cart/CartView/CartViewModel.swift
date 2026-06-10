import SwiftUI

@Observable
class CartViewModel: RoutableViewModel<CartRouter> {
    
    override init(router: CartRouter) {
        super.init(router: router)
    }
}
