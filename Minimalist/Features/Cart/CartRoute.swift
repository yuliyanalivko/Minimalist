import SwiftUI

enum CartRoute: Routable {
    case cart
    case itemDetails(title: String, id: String)
    
    var title: String {
        switch self {
        case .cart:
            "Cart"
        case .itemDetails(let title, _):
            title
        }
    }
}
