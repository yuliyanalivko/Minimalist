import SwiftUI

enum CartRoute: Routable {
    case cart
    case itemDetails(title: String, id: String)
    case checkout(items: [Item])
    
    var title: String {
        switch self {
        case .cart:
            "Cart"
        case .itemDetails(let title, _):
            title
        case .checkout(_):
            "Buy"
        }
    }
}
