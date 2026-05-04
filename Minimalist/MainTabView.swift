import SwiftUI

struct MainTabView: View {
    enum Tab: String, CaseIterable {
        case catalog
        case favorites
        case cart
        case settings
        
        var title: String {
            rawValue.capitalized
        }
        
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
    
    private let tabs = Tab.allCases.map { tab in
        TabItem(
            title: tab.title,
            icon: tab.icon
        )
    }
    
    var body: some View {
        FlatTabView(tabs: tabs)
    }
}

#Preview {
    MainTabView()
}
