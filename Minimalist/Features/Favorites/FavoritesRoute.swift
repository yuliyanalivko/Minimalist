import SwiftUI

enum FavoritesRoute: Routable {
    case favorites
    case itemDetails(title: String, id: String)

    var title: String {
        switch self {
        case .favorites:
            "Favorites"
        case .itemDetails(let title, _):
            title
        }
    }
}
