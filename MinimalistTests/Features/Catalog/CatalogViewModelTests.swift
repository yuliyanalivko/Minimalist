import Testing
@testable import Minimalist

@MainActor
struct CatalogViewModelTests {

    @Test("sets up shared router instance correctly")
    func init_setsUpSharedRouter() async throws {
        let vm = CatalogViewModel(router: .init())
        
        #expect(vm.categoryViewModel.router === vm.router, "CategoryViewModel should share the main router instance")
        #expect(vm.itemListViewModel.router === vm.router, "ItemListViewModel should share the main router instance")
    }
    
    @Test("categorySearchText updates the CategoryViewModel.categorySearchText")
    func categorySearchText_Passthrough() {
        let vm = CatalogViewModel(router: .init())
        
        vm.categorySearchText = "Sofas"
        
        #expect(vm.categoryViewModel.searchText == "Sofas")
    }
    
    @Test("categorySearchText gets the CategoryViewModel.categorySearchText")
    func categorySearchText_getViewModelSearchText() {
        let vm = CatalogViewModel(router: .init())
        
        vm.categoryViewModel.searchText = "Sofas"
        
        #expect(vm.categorySearchText == "Sofas")
    }
    
    @Test("itemListSearchText gets the CategoryViewModel.categorySearchText")
    func itemListSearchText_Passthrough() {
        let vm = CatalogViewModel(router: .init())
        
        vm.itemListSearchText = "Sofas"
        
        #expect(vm.itemListViewModel.searchText == "Sofas")
    }
    
    @Test("itemListSearchText updates the ItemListViewModel state")
    func itemListSearchText_getViewModelSearchText() {
        let vm = CatalogViewModel(router: .init())
        
        vm.itemListViewModel.searchText = "Sofas"
        
        #expect(vm.itemListSearchText == "Sofas")
    }
    
    @Test("calls trackScreen with the correct screenName")
    func trackCatalogScreen_callLogEvent() {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = CatalogViewModel(router: .init(), analyticsManager: analyticsManager)
        
        vm.trackCatalogScreen()
        
        guard let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected parameters not to be nil")
           
            return
        }
        
        #expect(parameters[AnalyticsParamName.screenName.rawValue] as? String == "Catalog")
    }
}
