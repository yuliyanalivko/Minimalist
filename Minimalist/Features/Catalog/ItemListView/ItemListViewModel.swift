import SwiftUI

@Observable
class ItemListViewModel: RoutableViewModel<CatalogRouter> {
    var allItems: [Item] = []
    var searchText: String = ""
    
    var displayedItems: [Item] {
        allItems.filtered(by: searchText, key: \.name)
    }
    
    override init(router: CatalogRouter) {
        super.init(router: router)
        // TODO: remove later
        loadMock()
    }
    
    override init(router: CatalogRouter, analyticsManager: AnalyticsManager) {
        super.init(router: router, analyticsManager: analyticsManager)
        // TODO: remove later
        loadMock()
    }
    
    // TODO: remove later
    func loadMock() {
        let data = itemsMock.data(using: .utf8)!
        allItems = try! JSONDecoder().decode([Item].self, from: data)
        allItems = allItems.map { item in
            guard let thumbnailUrl = item.thumbnailUrl,
                  let url = URL(string: thumbnailUrl) else {
                return item
            }
            
            var updatedItem = item
                         
            updatedItem.thumbnailUrl = url.resized(to: 500).absoluteString
            
            return updatedItem
        }
    }
    
    func toggleFavorite(_ item: Item) {
        if let index = allItems.firstIndex(where: { $0.id == item.id }) {
            allItems[index].isFavorited.toggle()

            logToggleFavoriteEvent(item: allItems[index])
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
}
