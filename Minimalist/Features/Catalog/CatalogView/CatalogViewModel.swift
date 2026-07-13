import SwiftUI

@Observable
class CatalogViewModel: RoutableViewModel<CatalogRouter> {
    
    var categoryViewModel: CategoryViewModel {
        _categoryViewModel
    }
    
    var itemListViewModel: ItemListViewModel {
        _itemListViewModel
    }
    
    var categorySearchText: String {
        get {
            _categoryViewModel.searchText
        }
        set {
            _categoryViewModel.searchText = newValue
        }
    }
    
    var itemListSearchText: String {
        get {
            _itemListViewModel.searchText
        }
        set {
            _itemListViewModel.searchText = newValue
        }
    }
    
    private var _categoryViewModel: CategoryViewModel
    private var _itemListViewModel: ItemListViewModel

    override init(router: CatalogRouter, analyticsManager: AnalyticsManager? = nil) {
        self._categoryViewModel = CategoryViewModel(router: router)
        self._itemListViewModel = ItemListViewModel(router: router)
        
        super.init(router: router, analyticsManager: analyticsManager)
    }
    
    func logViewItemListEvent() {
        guard let selectedCategory = categoryViewModel.selectedCategory else {
            return
        }
        
        itemListViewModel.logViewItemListEvent(id: selectedCategory.id, name: selectedCategory.name)
    }
    
    func logItemListSearchEvent() {
        guard let selectedCategory = categoryViewModel.selectedCategory else {
            return
        }
        
        itemListViewModel.logSearchEvent(categoryName: selectedCategory.name)
    }
    
    func logCategorySearchEvent() {
        categoryViewModel.logSearchEvent()
    }
    
    func trackCatalogScreen() {
        //TODO: replace "Catalog" with route title once the base router is ready
        logEvent(AnalyticsEvent(
            name: .screenView,
            parameters: [.screenName: "Catalog"]
        ))
    }
}
