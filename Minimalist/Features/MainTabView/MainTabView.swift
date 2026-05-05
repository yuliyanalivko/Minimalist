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
        
        @ViewBuilder
        var view: some View {
            switch self {
            case .catalog:
                CatalogView()
                
            case .favorites:
                Text(self.title)
                
            case .cart:
                Text(self.title)
                
            case .settings:
                Text(self.title)
            }
        }
    }
    
    private let viewModel = FlatTabViewModel(
        tabs: Tab.allCases.map { tab in
            TabItem(
                title: tab.title,
                icon: tab.icon,
                view: AnyView(tab.view)
            )
        }
    )
    
    var body: some View {
        FlatTabView(viewModel: viewModel!)
    }
}

#Preview {
    MainTabView()
}
