import Testing
@testable import Minimalist

@MainActor
struct CartViewModelTests {
    
    @Test("Should share the router with CartListViewModel")
    func init_shareRouter() {
        let router = CartRouter()
        let vm = CartViewModel(router: router)
        
        #expect(vm.cartListViewModel.router === router)
        #expect(vm.router === router)
    }
    
    @Test("Should create a new instance of CheckoutViewModel if it's nil")
    func updateCheckoutViewModel_createNewInstance_whenNil() {
        let router = CartRouter()
        let vm = CartViewModel(router: router)

        vm.updateCheckoutViewModel(items: [item, item2])
        
        #expect(vm.checkoutViewModel?.items == [item, item2])
    }
    
    @Test("Should update checkoutViewModel items when items have been changed")
    func updateCheckoutViewModel_updateItems_whenChanged() {
        let router = CartRouter()
        let vm = CartViewModel(router: router)
        vm.checkoutViewModel = CheckoutViewModel(router: router, items: [item, item2])

        vm.updateCheckoutViewModel(items: [item])
        
        #expect(vm.checkoutViewModel?.items == [item])
    }
    
    @Test("Should call trackScreen with the correct screenName")
    func trackCartScreen_callLogEvent() {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let router = CartRouter()
        let vm = CartViewModel(router: router, analyticsManager: analyticsManager)
        vm.cartListViewModel.searchText = " sofa "
        
        vm.trackCartScreen()
        
        guard let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected parameters not to be nil")
            
            return
        }
        
        #expect(parameters[AnalyticsParamName.screenName.rawValue] as? String == "Cart")
    }
    
    @Test("Should forward search logging to CartListViewModel")
    func logCartListSearchEvent_forwardToListViewModel() {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let router = CartRouter()
        let vm = CartViewModel(router: router)
        vm.cartListViewModel = CartListViewModel(
            router: router,
            analyticsManager: analyticsManager
        )
        vm.cartListViewModel.searchText = " sofa "
        
        vm.logCartListSearchEvent()
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")
            
            return
        }
        
        #expect(name == AnalyticsEventName.applySearch.rawValue)
        #expect(parameters[AnalyticsParamName.searchTerm.rawValue] as? String == "sofa")
    }
}
