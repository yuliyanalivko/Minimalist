import SwiftUI

@Observable
class FavoritesViewModel: RoutableViewModel<FavoritesRouter> {
    let cartService: CartManaging
    var favoriteListViewModel: FavoriteListViewModel

    init(
        router: FavoritesRouter,
        cartService: CartManaging = CartService()
    ) {
        self.cartService = cartService
        favoriteListViewModel = FavoriteListViewModel(router: router, cartService: cartService)
        super.init(router: router)
    }
    
    func trackFavoritesScreen() {
        logEvent(AnalyticsEvent(
            name: .screenView,
            parameters: [.screenName: FavoritesRoute.favorites.title]
        ))
    }
    
    func logFavoriteListSearchEvent() {
        favoriteListViewModel.logSearchEvent()
    }
}
