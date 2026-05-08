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
    
    @Test("showRoundedTabBar is true by default")
    func showRoundedTabBar_true_byDefault() {
        let vm = AppViewModel()

        #expect(vm.showRoundedTabBar == true)
    }
    
    @Test("updates showRoundedTabBar value")
    func showRoundedTabBar_updateValue() {
        let vm = AppViewModel()

        vm.showRoundedTabBar = false

        #expect(vm.showRoundedTabBar == false)
    }
}
