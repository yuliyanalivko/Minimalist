import Testing
import SwiftUI
@testable import Minimalist

struct BaseViewModelModelTests {
    
    @Test("errorMessage returns correct message")
    func errorMessage_returnCorrectMessage() {
        let vm = BaseViewModel()
        let error = TestError.unknownError

        vm.setError(error)

        #expect(vm.errorMessage == "Unknown error occured")
    }
    
    @Test("setError stores passed error")
    func setError_storesError() {
        let vm = BaseViewModel()
        let error = TestError.unknownError

        vm.setError(error)

        #expect(vm.error as? TestError == error)
    }
    
    @Test("clearError removes current error")
    func clearError_removesError() {
        let vm = BaseViewModel()

        vm.setError(TestError.unknownError)
        vm.clearError()

        #expect(vm.error == nil)
        #expect(vm.errorMessage == nil)
    }
}

private enum TestError: LocalizedError {
    case unknownError

    var errorDescription: String? {
        switch self {
        case .unknownError:
            return "Unknown error occured"
        }
    }
}
