import SwiftUI

@Observable
class ItemListViewModel: BaseViewModel {
    var router: CatalogRouter
    var allItems: [Item] = []
    var searchText: String = ""
    
    var items: [Item] {
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
        }
    }
    
    func handleItemClick(item: Item) {
        router.navigate(to: CatalogRoute.itemDetails(title: item.name, id: item.id))
    }
}
