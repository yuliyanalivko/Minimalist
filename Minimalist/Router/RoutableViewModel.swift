import SwiftUI

@Observable
class RoutableViewModel<T: Router>: BaseViewModel {
    var router: T
    
    init(
        router: T,
        analyticsManager: AnalyticsManager? = nil,
        toastManager: ToastManaging? = nil
    ) {
        self.router = router
        super.init(analyticsManager: analyticsManager, toastManager: toastManager)
    }
}
