import SwiftUI

enum CartRoute: Routable {
    case cart
    
    var title: String {
        switch self {
        case .cart:
            "Cart"
        }
    }
}
