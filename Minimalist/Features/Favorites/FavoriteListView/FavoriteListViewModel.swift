import Foundation

@Observable
class FavoriteListViewModel: RoutableViewModel<FavoritesRouter> {
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
    
    private let favoritesDataCoordinator: FavoritesDataCoordinator
    private let cartDataCoordinator: CartDataCoordinator

    init(
        router: FavoritesRouter,
        favoritesDataCoordinator: FavoritesDataCoordinator = FavoritesDataCoordinator(),
        cartDataCoordinator: CartDataCoordinator = CartDataCoordinator(),
        analyticsManager: AnalyticsManager? = nil
    ) {
        self.favoritesDataCoordinator = favoritesDataCoordinator
        self.cartDataCoordinator = cartDataCoordinator
        super.init(router: router, analyticsManager: analyticsManager)
    }
    
    func fetchFavoriteItems() async {
        if allItems.isEmpty == true {
            isLoading = true
        }
        
        defer {
            isLoading = false
        }
        
        do {
            for try await items in favoritesDataCoordinator.getFavorites() {
                allItems = mapUrls(of: items)
                isLoading = false
            }
            
        } catch {
            setError(error)
        }
    }
    
    func toggleCart(item: Item) async {
        if let index = allItems.firstIndex(where: { $0.id == item.id }) {
            do {
                allItems[index].isAddedToCart.toggle()
                
                if allItems[index].isAddedToCart {
                    try await cartDataCoordinator.addToCart(id: item.id)
                } else {
                    try await cartDataCoordinator.removeFromCart(id: item.id)
                }
                
                logCartEvent(item: allItems[index])
            } catch {
                allItems[index].isAddedToCart.toggle()
                setError(error)
            }
        }
    }
        
    func removeFromFavorites(_ item: Item) async {
        if let index = allItems.firstIndex(where: { $0.id == item.id }) {
            do {
                try await favoritesDataCoordinator.removeFromFavorites(id: item.id)
                
                logRemoveFromFavoritesEvent(item: allItems[index])
                allItems.remove(at: index)
            } catch {
                setError(error)
            }
        }
    }
    
    func handleItemClick(item: Item) {
        router.navigate(to: FavoritesRoute.itemDetails(title: item.name, id: item.id))
    }
    
    func logSearchEvent() {
        let searchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !searchTerm.isEmpty else { return }
        
        logEvent(AnalyticsEvent(
            name: AnalyticsEventName.applySearch,
            parameters: [AnalyticsParamName.searchTerm: searchTerm]
        ))
    }
    
    private func logCartEvent(item: Item) {
        let eventName: AnalyticsEventName = item.isAddedToCart
        ? AnalyticsEventName.addToCart
        : AnalyticsEventName.removeFromCart
        
        logEvent(AnalyticsEvent(
            name: eventName,
            parameters: [.itemId: item.id, .itemName: item.name]
        ))
    }
    
    
    private func logRemoveFromFavoritesEvent(item: Item) {
        logEvent(AnalyticsEvent(
            name: AnalyticsEventName.removeFromWishlist,
            parameters: [.itemId: item.id, .itemName: item.name]
        ))
    }
    
    private func mapUrls(of items: [Item]) -> [Item] {
        URLHelper.mapUrls(of: items, keyPath: \.thumbnailUrl)
    }
}
