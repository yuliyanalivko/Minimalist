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
    
    var items: [SelectableListItemRepresentable] {
        Tab.allCases.map { tab in
            SelectableListItem(
                title: tab.title,
                icon: tab.icon,
                highlightedColor: Color.AppColor.primary,
                inactiveColor: Color.AppColor.textSecondary,
                badgeText: badgeText(for: tab)
            )
        }
    }
    
    var selectedItem: SelectableListItemRepresentable? {
        item(at: selectedItemIndex)
    }
    
    private(set) var showRoundedTabBar: Bool
    private(set) var selectedItemIndex: Int = 0
    private let cartService: CartManaging
    private(set) var notificationId: String?
    
    init(cartService: CartManaging = CartService()) {
        showRoundedTabBar = AppConfigurationManager.shared.remoteConfigManager.isRoundTabBarEnabled
        catalogViewModel = CatalogViewModel(router: catalogRouter, cartService: cartService)
        favoritesViewModel = FavoritesViewModel(router: favoritesRouter, cartService: cartService)
        cartViewModel = CartViewModel(router: cartRouter, cartService: cartService)
        settingsViewModel = SettingsViewModel(router: settingsRouter)
        self.cartService = cartService
        
        super.init()
    }
    
    func select(_ index: Int) {
        selectedItemIndex = index
    }
    
    func loadCartItems() async {
        await cartService.loadCartItems()
    }
    
    func scheduleNotification() {
        guard cartService.itemCount > 0 else {
            return
        }
        
        notificationId = AppConfigurationManager.shared.notificationManager.showNotification(
            title: "Did you forget something?",
            message: "Your items are still waiting in your cart. Come back and finish checking out!",
            timeInterval: 60
        )
    }
    
    func cancelNotification() {
        guard let id = notificationId else {
            return
        }
        
        AppConfigurationManager.shared.notificationManager.cancelSheduledNotification(withIdentifier: id)
        
        notificationId = nil
    }
    
    private func badgeText(for tab: Tab) -> String? {
        guard tab == .cart else {
            return nil
        }
        
        return cartService.itemCount > 99 ? "99+" : "\(cartService.itemCount)"
    }
}
