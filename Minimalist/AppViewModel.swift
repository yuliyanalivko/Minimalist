import SwiftUI

enum AppLoadingState {
    case initializing
    case readyToProceed
    case started
}

@Observable
class AppViewModel: BaseViewModel {
    var currentState: AppLoadingState = .initializing

    func configureSDKs() async {
        currentState = .initializing
        
        await RemoteConfigManager.shared.fetchAndActivate()
        
#if DEBUG
        if RemoteConfigManager.shared.isTestingNotificationsEnabled {
            await NotificationManager.shared.requestAuthorization()
        }
#endif
        
        currentState = .readyToProceed
    }
    
    func startTheApp() {
        currentState = .started
    }
}
