import SwiftUI

@Observable
class FavoritesViewModel: RoutableViewModel<FavoritesRouter> {
    var favoriteListViewModel: FavoriteListViewModel

    init(router: FavoritesRouter) {
        favoriteListViewModel = FavoriteListViewModel(router: router)
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
