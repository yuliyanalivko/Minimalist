import SwiftUI

@Observable
class FavoritesViewModel: RoutableViewModel<FavoritesRouter> {
    
    override init(router: FavoritesRouter) {
        super.init(router: router)
    }
}
