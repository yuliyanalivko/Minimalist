import SwiftUI

@Observable
class CatalogViewModel: BaseViewModel {
    var router: CatalogRouter
    
    var categoryViewModel: CategoryViewModel {
        _categoryViewModel
    }
    
    var itemListViewModel: ItemListViewModel {
        _itemListViewModel
    }
    
    var categorySearchText: String {
        get {
            _categoryViewModel.categorySearchText
        }
        set {
            _categoryViewModel.categorySearchText = newValue
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
    
    override init() {
        let router = CatalogRouter()
        
        self.router = router
        
        self._categoryViewModel = CategoryViewModel(router: router)
        self._itemListViewModel = ItemListViewModel(router: router)
    }
}
