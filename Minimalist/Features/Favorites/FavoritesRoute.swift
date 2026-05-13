import SwiftUI

enum FavoritesRoute: Hashable {
    case favorites
    
    var title: String {
        switch self {
        case .favorites:
            "Favorites"
        }
    }
}
