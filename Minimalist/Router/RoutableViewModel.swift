import SwiftUI

@Observable
class RoutableViewModel<T: Router>: BaseViewModel {
    var router: T

    init(router: T) {
        self.router = router
        super.init()
    }
    
    init(router: T, analyticsManager: AnalyticsManager) {
        self.router = router
        super.init(analyticsManager: analyticsManager)
    }
}
