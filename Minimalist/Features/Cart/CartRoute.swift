import SwiftUI

enum CartRoute: Hashable {
    case cart
    
    var title: String {
        switch self {
        case .cart:
            "Cart"
        }
    }
}
