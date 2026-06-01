import Testing
import SwiftUI
@testable import Minimalist

struct AppViewModelModelTests {
    
    let vm = AppViewModel()
    
    final class FirebaseMock: FirebaseConfiguring {
        
        private(set) var configureCalled = false
        
        func configure() {
            configureCalled = true
        }
    }
    
    @Test("verify the initial state of the currentState is .initializing")
    func currentState_initValue_initializing() {
        #expect(vm.currentState == .initializing)
    }
    
    @MainActor
    @Test("should set currentState to .readyToProceed")
    func configureSDKs_setCurrentStateToReadyToProcess() async {
        let firebase = FirebaseMock()
        let vm = AppViewModel(firebase: firebase)
        
        await vm.configureSDKs()
        
        #expect(vm.currentState == .readyToProceed)
        #expect(firebase.configureCalled)
    }
    
    @Test("should set currentState to .started")
    func startTheApp_setCurrentStateToStarted() {
        vm.currentState = .readyToProceed
        vm.startTheApp()
        
        #expect(vm.currentState == .started)
    }
}
