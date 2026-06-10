import SwiftUI

enum FavoritesRoute: Routable {
    case favorites
    
    var title: String {
        switch self {
        case .favorites:
            "Favorites"
        }
    }
}
