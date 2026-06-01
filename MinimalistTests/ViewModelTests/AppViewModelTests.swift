import Testing
import SwiftUI
@testable import Minimalist

struct AppViewModelModelTests {
    
    let vm = AppViewModel()

    @Test("verify the initial state of the currentState is .initializing")
    func currentState_initValue_initializing() {
        #expect(vm.currentState == .initializing)
    }
    
    @MainActor
    @Test("should set currentState to .readyToProceed")
    func configureSDKs_setCurrentStateToReadyToProcess() async {
        let vm = AppViewModel()
        
        await vm.configureSDKs()
        
        #expect(vm.currentState == .readyToProceed)
    }
    
    @Test("should set currentState to .started")
    func startTheApp_setCurrentStateToStarted() {
        vm.currentState = .readyToProceed
        vm.startTheApp()
        
        #expect(vm.currentState == .started)
    }
}
