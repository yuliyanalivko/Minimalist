import SwiftUI
import Firebase

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
        
        FirebaseApp.configure()
        await RemoteConfigManager.shared.fetchAndActivate()
        
        currentState = .readyToProceed
    }
    
    func startTheApp() {
        currentState = .started
    }
}
