import Testing
@testable import Minimalist

@MainActor
struct FavoritesViewModelTests {
    
    @Test("shares the router with FavoriteListViewModel")
    func init_sharesRouter() {
        let router = FavoritesRouter()
        let vm = FavoritesViewModel(router: router)
        
        #expect(vm.favoriteListViewModel.router === router)
        #expect(vm.router === router)
    }
    
    @Test("forwards search logging to FavoriteListViewModel")
    func logFavoriteListSearchEvent_forwardsToListViewModel() {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let router = FavoritesRouter()
        let vm = FavoritesViewModel(router: router)
        vm.favoriteListViewModel = FavoriteListViewModel(
            router: router,
            analyticsManager: analyticsManager
        )
        vm.favoriteListViewModel.searchText = " sofa "
        
        vm.logFavoriteListSearchEvent()
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")
            
            return
        }
        
        #expect(name == AnalyticsEventName.applySearch.rawValue)
        #expect(parameters[AnalyticsParamName.searchTerm.rawValue] as? String == "sofa")
    }
}
