import SwiftUI

@Observable
class CatalogViewModel: RoutableViewModel<CatalogRouter> {
    
    var itemListViewModel: ItemListViewModel?
    let categoryViewModel: CategoryViewModel
    let cartService: CartService
    
    var categorySearchText: String {
        get {
            categoryViewModel.searchText
        }
        set {
            categoryViewModel.searchText = newValue
        }
    }
    
    var itemListSearchText: String {
        get {
            itemListViewModel?.searchText ?? ""
        }
        set {
            itemListViewModel?.searchText = newValue
        }
    }
    
    
    init(
        router: CatalogRouter,
        cartService: CartService = CartService(),
        analyticsManager: AnalyticsManager? = nil
    ) {
        self.cartService = cartService
        self.categoryViewModel = CategoryViewModel(router: router)
        
        super.init(router: router, analyticsManager: analyticsManager)
    }
    
    func updateItemListViewModel(id: String) {
        if let existing = itemListViewModel, existing.categoryId == id {
            return
        }
        
        itemListViewModel = ItemListViewModel(categoryId: id, router: router)
    }
    
    func logViewItemListEvent() {
        guard let selectedCategory = categoryViewModel.selectedCategory,
        let itemListViewModel else {
            return
        }
        
        itemListViewModel.logViewItemListEvent(id: selectedCategory.id, name: selectedCategory.name)
    }
    
    func logItemListSearchEvent() {
        guard let selectedCategory = categoryViewModel.selectedCategory,
        let itemListViewModel else {
            return
        }
        
        itemListViewModel.logSearchEvent(categoryName: selectedCategory.name)
    }
    
    func logCategorySearchEvent() {
        categoryViewModel.logSearchEvent()
    }
    
    func trackCatalogScreen() {
        logEvent(AnalyticsEvent(
            name: .screenView,
            parameters: [.screenName: CatalogRoute.category.title]
        ))
    }
}
