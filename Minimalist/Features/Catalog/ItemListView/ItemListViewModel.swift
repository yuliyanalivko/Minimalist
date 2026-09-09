import Foundation

@Observable
class ItemListViewModel: RoutableViewModel<CatalogRouter> {
    let categoryId: String
    var allItems: [Item] = []
    var searchText: String = ""
    
    var activeSheet: ItemListSheet?
    var sortBySheetViewModel: SortBySheetViewModel?
    var filterBySheetViewModel: FilterBySheetViewModel?
    
    var appliedFilterState: FilterState?
    
    var displayedItems: [Item] {
        var items = allItems.filtered(by: searchText, key: \.name)
        
        if let appliedFilterState {
            items = filterItems(items, by: appliedFilterState)
        }
        
        if let sortBySheetViewModel,
           let sortOption = sortBySheetViewModel.selectedOption,
           let sortOrder = sortBySheetViewModel.selectedOrder {
            return sortItems(items, by: sortOption, in: sortOrder)
        }
        
        return items
    }
    
    var subcategories: [SubCategory] {
        Array(Set(allItems.compactMap { $0.subcategory }))
            .sorted { $0.name < $1.name }
    }
    
    var priceBounds: ClosedRange<Double> {
        let prices = allItems.map(\.price)
        
        guard let lowest = prices.min(), let highest = prices.max() else {
            return 0...1000
        }
        
        return lowest.rounded(.down)...highest.rounded(.up)
    }
    
    var state: ContentState<[Item]> {
        if isLoading { return .loading }
        
        if displayedItems.isEmpty {
                        
            guard searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return .emptySearch
            }
            
            guard appliedFilterState == nil else {
                return .emptyFilter
            }
            
            return .empty
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
        activeSheet = .sort
    }
    
    func triggerFilterSheet() {
        if let filterBySheetViewModel {
            filterBySheetViewModel.categories = subcategories
            filterBySheetViewModel.priceBounds = priceBounds
        } else {
            filterBySheetViewModel = FilterBySheetViewModel(
                filterState: appliedFilterState ?? FilterState(),
                categories: subcategories,
                priceBounds: priceBounds
            ) { [weak self] filterState in
                self?.applyFilters(filterState)
            }
        }
        
        filterBySheetViewModel?.configureInitialState()
        activeSheet = .filter
    }
    
    func applyFilters(_ filterState: FilterState) {
        appliedFilterState = filterState.isEmpty ? nil : filterState
        logFilterEvent(filters: filterState)
    }
    
    private func filterItems(_ items: [Item], by state: FilterState) -> [Item] {
        items.filter { item in
            if let categoryId = state.categoryId, item.subcategory?.id != categoryId {
                return false
            }
            
            if let priceRange = state.priceRange, !priceRange.contains(item.price) {
                return false
            }
            
            return item.rating >= state.minRating
        }
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
    
    private func logFilterEvent(filters: FilterState) {
        let priceRange = filters.priceRange ?? priceBounds
        
        logEvent(AnalyticsEvent(
            name: AnalyticsEventName.applyFilter,
            parameters: [
                .filterCategory: filters.categoryId ?? "",
                .filterRating: filters.minRating,
                .filterMinPrice: priceRange.lowerBound,
                .filterMaxPrice: priceRange.upperBound
            ]
        ))
    }
    
    private func mapUrls(of items: [Item]) -> [Item]{
        URLHelper.mapUrls(of: items, keyPath: \.thumbnailUrl)
    }
}
