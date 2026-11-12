import SwiftUI
import Firebase

enum AppLoadingState {
    case initializing
    case readyToProceed
    case started
}

@Observable
class AppViewModel: BaseViewModel {
    var isStarted: Bool = true//false
    
    func startTheApp() {
        isStarted = false//true
    }
}
