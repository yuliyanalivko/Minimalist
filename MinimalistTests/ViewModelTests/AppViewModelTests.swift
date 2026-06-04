import Testing
import SwiftUI
@testable import Minimalist

struct AppViewModelModelTests {
    
    let vm = AppViewModel()

    @Test("verify the initial state of the isStarted is false")
    func isStarted_initValue_initializing() {
        #expect(vm.isStarted == false)
    }
    
    @MainActor
    @Test("should set isStarted to true")
    func startTheApp_setIsStartedToTrue() async {
        let vm = AppViewModel()
        
        await vm.startTheApp()
        
        #expect(vm.isStarted)
    }
}
