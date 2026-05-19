import SwiftUI

@Observable
class CatalogViewModel {
    var router: CatalogRouter
    
    var categoryViewModel: CategoryViewModel
    var itemListViewModel: ItemListViewModel
    
    init() {
        let router = CatalogRouter()
        
        self.router = router
        
        self.categoryViewModel = CategoryViewModel(router: router)
        self.itemListViewModel = ItemListViewModel(router: router)
    }
}
