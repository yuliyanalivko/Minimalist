import SwiftUI
import Combine

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

    let catalogRouter = CatalogRouter()
    let favoritesRouter = FavoritesRouter()
    let cartRouter = CartRouter()
    let settingsRouter = SettingsRouter()

    var catalogViewModel: CatalogViewModel
    var favoritesViewModel: FavoritesViewModel
    var cartViewModel: CartViewModel
    var settingsViewModel: SettingsViewModel

    var isKeyboardVisible = false

    var keyboardPublisher: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification).map { _ in true },
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification).map { _ in false }
        ).eraseToAnyPublisher()
    }
    
    let items: [SelectableListItemRepresentable] = Tab.allCases.map { tab in
        SelectableListItem(
            title: tab.title,
            icon: tab.icon,
            highlightedColor: Color.AppColor.primary,
            inactiveColor: Color.AppColor.textSecondary
        )
    }
    
    var selectedItem: SelectableListItemRepresentable? {
        item(at: selectedItemIndex)
    }
    
    private(set) var showRoundedTabBar: Bool
    
    private(set) var selectedItemIndex: Int = 0
    
    init() {
        showRoundedTabBar = RemoteConfigManager().isRoundTabBarEnabled
        catalogViewModel = CatalogViewModel(router: catalogRouter)
        favoritesViewModel = FavoritesViewModel(router: favoritesRouter)
        cartViewModel = CartViewModel(router: cartRouter)
        settingsViewModel = SettingsViewModel(router: settingsRouter)
        super.init()
    }
    
    func select(_ index: Int) {
        selectedItemIndex = index
    }
}
