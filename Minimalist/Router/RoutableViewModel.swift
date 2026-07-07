import SwiftUI

@Observable
class RoutableViewModel<T: Router>: BaseViewModel {
    var router: T
    
    init(
        router: T,
        analyticsManager: AnalyticsManager? = nil,
    ) {
        self.router = router
        super.init(analyticsManager: analyticsManager)
    }
}
