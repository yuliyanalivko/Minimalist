import SwiftUI

@Observable
class FavoritesViewModel: RoutableViewModel<FavoritesRouter> {
    
    init(router: FavoritesRouter) {
        super.init(router: router)
    }
}
