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
        let sut = BaseViewModel()

        sut.setError(TestError.unknownError)
        sut.clearError()

        #expect(sut.error == nil)
        #expect(sut.errorMessage == nil)
    }
    
    @Test("Should display message via ToastManager")
    @MainActor
    func showToast_displayMessage() {
        let vm = BaseViewModel(analyticsManager: nil)
        
        vm.showToast(message: "Something went wrong", style: .error)
        
        #expect(ToastManager.shared.current?.message == "Something went wrong")
        #expect(ToastManager.shared.current?.style == .error)
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
