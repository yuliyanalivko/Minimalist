import SwiftUI

@Observable
class ItemListViewModel: BaseViewModel {
    var router: CatalogRouter
    var allItems: [Item] = []
    var searchText: String = ""
    
    var displayedItems: [Item] {
        allItems.filtered(by: searchText, key: \.name)
    }
    
    init(router: CatalogRouter) {
        self.router = router
        super.init()
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

        logEvent(
            .applySearch(
                searchTerm: searchTerm,
                categoryName: categoryName
            )
        )
    }
    
    func logViewItemListEvent(id: String, name: String) {
        logEvent(
            .viewItemList(
                id: id,
                name: name
            )
        )
    }

    private func logToggleFavoriteEvent(item: Item) {
        let event: AnalyticsEvent = item.isFavorited
        ? .addToWishlist(id: item.id, name: item.name)
        : .removeFromWishlist(id: item.id, name: item.name)
        
        logEvent(event)
    }
}
