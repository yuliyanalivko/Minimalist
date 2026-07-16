import SwiftUI

@Observable
class ItemListViewModel: RoutableViewModel<CatalogRouter> {
    let id: String
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
    
    private let catalogDataCoordinator: CatalogDataCoordinator
    private let favoritesDataCoordinator: FavoritesDataCoordinator
    
    init(
        id: String,
        router: CatalogRouter,
        catalogDataCoordinator: CatalogDataCoordinator = CatalogDataCoordinator(),
        favoritesDataCoordinator: FavoritesDataCoordinator = FavoritesDataCoordinator(),
        analyticsManager: AnalyticsManager? = nil
    ) {
        self.id = id
        self.catalogDataCoordinator = catalogDataCoordinator
        self.favoritesDataCoordinator = favoritesDataCoordinator
        super.init(router: router, analyticsManager: analyticsManager)
    }
    
    func fetchItems() async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            let items = try await catalogDataCoordinator.getItems(categoryId: id)
            allItems = mapUrls(of: items)
        } catch {
            setError(error)
        }
    }
    
    func toggleFavorite(_ item: Item) async {
        if let index = allItems.firstIndex(where: { $0.id == item.id }) {
            do {
                allItems[index].isFavorited.toggle()
                
                if item.isFavorited {
                    try await favoritesDataCoordinator.addToFavorites(id: item.id)
                } else {
                    try await favoritesDataCoordinator.removeFromFavorites(id: item.id)
                }
                
                logToggleFavoriteEvent(item: allItems[index])
            } catch {
                allItems[index].isFavorited.toggle()
                setError(error)
            }
        }
    }
    
    func handleItemClick(item: Item) {
        router.navigate(to: CatalogRoute.itemDetails(title: item.name, id: item.id))
    }
    
    func logSearchEvent(categoryName: String) {
        let searchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !searchTerm.isEmpty else { return }
        
        logEvent(AnalyticsEvent(
            name: AnalyticsEventName.applySearch,
            parameters: [AnalyticsParamName.searchTerm: searchTerm, AnalyticsParamName.categoryName: categoryName]
        ))
    }
    
    func logViewItemListEvent(id: String, name: String) {
        logEvent(AnalyticsEvent(
            name: AnalyticsEventName.viewItemList,
            parameters: [AnalyticsParamName.listId: id, AnalyticsParamName.listName: name]
        ))
    }
    
    private func logToggleFavoriteEvent(item: Item) {
        let eventName: AnalyticsEventName = item.isFavorited
        ? AnalyticsEventName.addToWishlist
        : AnalyticsEventName.removeFromWishlist
        
        logEvent(AnalyticsEvent(
            name: eventName,
            parameters: [.itemId: item.id, .itemName: item.name]
        ))
    }
    
    private func mapUrls(of items: [Item]) -> [Item]{
        items.map { item in
            guard let thumbnailUrl = item.thumbnailUrl,
                  let url = URL(string: thumbnailUrl) else {
                return item
            }
            
            var updatedItem = item
            
            updatedItem.thumbnailUrl = thumbnailUrl
            updatedItem.thumbnailUrl = url.resized(to: 500).absoluteString
            
            return updatedItem
        }
    }
}
