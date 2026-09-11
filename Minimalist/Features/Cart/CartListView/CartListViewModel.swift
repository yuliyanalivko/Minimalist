import Foundation

@Observable
class CartListViewModel: RoutableViewModel<CartRouter> {
    var allItems: [Item] = []
    var searchText: String = ""
    
    var displayedItems: [Item] {
        allItems.filtered(by: searchText, key: \.name)
    }
    
    var state: ContentState<[Item]> {
        if isLoading { return .loading }
        
        if displayedItems.isEmpty {
            return searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? .empty
            : .emptySearch
        }
        
        return .content(displayedItems)
    }
    
    private let cartDataCoordinator: CartDataCoordinator

    init(
        router: CartRouter,
        cartDataCoordinator: CartDataCoordinator = CartDataCoordinator(),
        analyticsManager: AnalyticsManager? = nil
    ) {
        self.cartDataCoordinator = cartDataCoordinator
        super.init(router: router, analyticsManager: analyticsManager)
    }
    
    func fetchCartItems() async {
        if allItems.isEmpty == true {
            isLoading = true
        }
        
        defer {
            isLoading = false
        }
        
        do {
            for try await items in cartDataCoordinator.getCartItems() {
                allItems = mapUrls(of: items)
                isLoading = false
            }
            
        } catch {
            setError(error)
        }
    }
        
    func removeFromCart(_ item: Item) async {
        if let index = allItems.firstIndex(where: { $0.id == item.id }) {
            do {
                try await cartDataCoordinator.removeFromCart(id: item.id)
                
                logRemoveFromCartEvent(item: allItems[index])
                allItems.remove(at: index)
            } catch {
                setError(error)
            }
        }
    }
    
    func handleItemClick(item: Item) {
        router.navigate(to: CartRoute.itemDetails(title: item.name, id: item.id))
    }
    
    func logSearchEvent() {
        let searchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !searchTerm.isEmpty else { return }
        
        logEvent(AnalyticsEvent(
            name: AnalyticsEventName.applySearch,
            parameters: [AnalyticsParamName.searchTerm: searchTerm]
        ))
    }
    
    private func logRemoveFromCartEvent(item: Item) {
        logEvent(AnalyticsEvent(
            name: AnalyticsEventName.removeFromCart,
            parameters: [.itemId: item.id, .itemName: item.name]
        ))
    }
    
    private func mapUrls(of items: [Item]) -> [Item] {
        URLHelper.mapUrls(of: items, keyPath: \.thumbnailUrl)
    }
}
