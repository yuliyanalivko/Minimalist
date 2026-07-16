import SwiftUI

@Observable
class CatalogViewModel: RoutableViewModel<CatalogRouter> {
    
    var itemListViewModel: ItemListViewModel?
    let categoryViewModel: CategoryViewModel
    
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
    
    
    override init(router: CatalogRouter, analyticsManager: AnalyticsManager? = nil) {
        self.categoryViewModel = CategoryViewModel(router: router)
        
        super.init(router: router, analyticsManager: analyticsManager)
    }
    
    func setItemListViewModel(_ itemListViewModel: ItemListViewModel) {
        self.itemListViewModel = itemListViewModel
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
