import SwiftUI
import Firebase

enum AppLoadingState {
    case initializing
    case readyToProceed
    case started
}

@Observable
class AppViewModel: BaseViewModel {
    var isStarted: Bool = false
    
    func startTheApp() {
        isStarted = true
    }
}
