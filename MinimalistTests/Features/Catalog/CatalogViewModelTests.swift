import Testing
@testable import Minimalist

@MainActor
struct CatalogViewModelTests {
    
    class SpyViewModel: CatalogViewModel {

        private(set) var trackedScreens: [String] = []

        override func trackScreen(_ screenName: String) {
            trackedScreens.append(screenName)
        }
    }
    
    @Test("sets up shared router instance correctly")
    func init_setsUpSharedRouter() async throws {
        let vm = CatalogViewModel()
        
        #expect(vm.categoryViewModel.router === vm.router, "CategoryViewModel should share the main router instance")
        #expect(vm.itemListViewModel.router === vm.router, "ItemListViewModel should share the main router instance")
    }
    
    @Test("categorySearchText updates the CategoryViewModel.categorySearchText")
    func categorySearchText_Passthrough() {
        let vm = CatalogViewModel()
        
        vm.categorySearchText = "Sofas"
        
        #expect(vm.categoryViewModel.searchText == "Sofas")
    }
    
    @Test("categorySearchText gets the CategoryViewModel.categorySearchText")
    func categorySearchText_getViewModelSearchText() {
        let vm = CatalogViewModel()
        
        vm.categoryViewModel.searchText = "Sofas"
        
        #expect(vm.categorySearchText == "Sofas")
    }
    
    @Test("itemListSearchText gets the CategoryViewModel.categorySearchText")
    func itemListSearchText_Passthrough() {
        let vm = CatalogViewModel()
        
        vm.itemListSearchText = "Sofas"
        
        #expect(vm.itemListViewModel.searchText == "Sofas")
    }
    
    @Test("itemListSearchText updates the ItemListViewModel state")
    func itemListSearchText_getViewModelSearchText() {
        let vm = CatalogViewModel()
        
        vm.itemListViewModel.searchText = "Sofas"
        
        #expect(vm.itemListSearchText == "Sofas")
    }
    
    @Test("calls trackScreen with the correct screenName")
    func trackCatalogScreen_callLogEvent() {
        let vm = SpyViewModel()
        
        vm.trackCatalogScreen()
        
        #expect(vm.trackedScreens == ["Catalog"])
    }
}
