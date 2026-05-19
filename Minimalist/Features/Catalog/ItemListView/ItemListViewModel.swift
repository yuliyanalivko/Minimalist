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
            guard let url = item.thumbnailUrl else {
                return item
            }
            
            var updatedItem = item
            
            updatedItem.thumbnailUrl = resizeImageUrl(url)
            
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
    
    private func resizeImageUrl(_ url: String) -> String {
        let imageSize: Int = 500
        let pattern = #/(id/\d+)/\d+/\d+/#
        
        let resizedUrl = url.replacing(pattern) { match in
            let idPart = match.output.1
            
            return "\(idPart)/\(imageSize)/\(imageSize)/"
        }
        
        return resizedUrl
    }
}
