import SwiftUI

@Observable
class MainTabViewModel: BaseViewModel, TabBarDataModel {
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
    
    private(set) var showRoundedTabBar: Bool
    
    let items: [TabBarItemConfigurable] = Tab.allCases.map { tab in
        TabBarItem(
            title: tab.title,
            icon: tab.icon,
            selectedColor: Color.AppColor.primary,
            unSelectedColor: Color.AppColor.textSecondary
        )
    }
    
    var selectedItem: TabBarItemConfigurable? {
        tabBarItem(at: selectedItemIndex)
    }
    
    private(set) var selectedItemIndex: Int = 0
    
    init() {
        showRoundedTabBar = RemoteConfigManager().isRoundTabBarEnabled
        super.init()
    }
    
    func select(_ index: Int) {
        selectedItemIndex = index
    }
}
