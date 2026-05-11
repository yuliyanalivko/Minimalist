import Testing
import SwiftUI
@testable import Minimalist

struct AppViewModelModelTests {
    
    @Test("isStarted is false by default")
    func isStatrted_false_byDefault() {
        let vm = AppViewModel()

        #expect(vm.isStarted == false)
    }
    
    @Test("updates isStarted value")
    func isStarted_updateValue() {
        let vm = AppViewModel()

        vm.isStarted = true

        #expect(vm.isStarted == true)
    }
}
