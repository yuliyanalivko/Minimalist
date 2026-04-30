import SwiftUI

struct MainTabView: View {
    enum Tab: String {
        case catalog = "Catalog"
        case favorites = "Favorites"
        case cart = "Cart"
        case settings = "Settings"
        
        var icon: String {
            switch self {
            case .catalog:
                return "square.grid.2x2.fill"
            case .favorites:
                return "heart.fill"
            case .cart:
                return "basket.fill"
            case .settings:
                return "gearshape.fill"
            }
        }
    }
    
    private let tabs: [TabItem] = [
        TabItem(
            title: Tab.catalog.rawValue,
            icon: Tab.catalog.icon,
            //TODO: view:
        ),
        TabItem(
            title: Tab.favorites.rawValue,
            icon: Tab.favorites.icon,
            //TODO: view:
        ),
        TabItem(
            title: Tab.cart.rawValue,
            icon: Tab.cart.icon,
            //TODO: view:
        ),
        TabItem(
            title: Tab.settings.rawValue,
            icon: Tab.settings.icon,
            //TODO: view:
        )
    ]
    
    var body: some View {
        FlatTabView(tabs: tabs)
    }
}

#Preview {
    MainTabView()
}
