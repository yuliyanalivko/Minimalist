import Foundation

@Observable
class ItemListViewModel: RoutableViewModel<CatalogRouter> {
    let categoryId: String
    var allItems: [Item] = []
    var searchText: String = ""
    
    var showSorting: Bool = false
    
    private(set) var sortOption: SortOption?
    private(set) var sortOrder: SortOrder?
    private(set) var sortBySheetViewModel: SortBySheetViewModel?
    
    var displayedItems: [Item] {
        let items = allItems.filtered(by: searchText, key: \.name)
        
        if let sortOrder, let sortOption {
            return sortItems(items, by: sortOption, in: sortOrder)
        }
        
        return items
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
        categoryId: String,
        router: CatalogRouter,
        catalogDataCoordinator: CatalogDataCoordinator = CatalogDataCoordinator(),
        favoritesDataCoordinator: FavoritesDataCoordinator = FavoritesDataCoordinator(),
        analyticsManager: AnalyticsManager? = nil
    ) {
        self.categoryId = categoryId
        self.catalogDataCoordinator = catalogDataCoordinator
        self.favoritesDataCoordinator = favoritesDataCoordinator
        super.init(router: router, analyticsManager: analyticsManager)
    }
    
    func fetchItems() async {
        if allItems.isEmpty == true {
            isLoading = true
        }
        
        defer {
            isLoading = false
        }
        
        do {
            for try await items in catalogDataCoordinator.getItems(categoryId: categoryId) {
                allItems = mapUrls(of: items)
                isLoading = false
            }
        } catch {
            setError(error)
        }
    }
    
    func toggleFavorite(_ item: Item) async {
        if let index = allItems.firstIndex(where: { $0.id == item.id }) {
            do {
                allItems[index].isFavorited.toggle()
                
                if allItems[index].isFavorited {
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
    
    func updateSorting(by option: SortOption?, in order: SortOrder?) {
        sortOption = option
        sortOrder = order
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
    
    func triggerSortBySheet() {
        sortBySheetViewModel = sortBySheetViewModel ?? SortBySheetViewModel()
        showSorting = true
    }
    
    private func sortItems(_ items: [Item], by option: SortOption, in order: SortOrder) -> [Item] {
        switch option {
        case .name:
            return items.sorted(by: \.name, order: order)
        case .price:
            return items.sorted(by: \.price, order: order)
        case .rating:
            return items.sorted(by: \.rating, order: order)
        }
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
