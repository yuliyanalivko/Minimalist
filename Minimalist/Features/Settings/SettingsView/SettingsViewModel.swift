import SwiftUI

@Observable
class SettingsViewModel: RoutableViewModel<SettingsRouter> {
    
    init(router: SettingsRouter) {
        super.init(router: router)
    }
}
