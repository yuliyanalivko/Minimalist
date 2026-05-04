import SwiftUI

@Observable class BaseViewModel {
    var isLoading: Bool = false
    
    private(set) var errorMessage: String?
    
    func setError(_ error: Error) {
        errorMessage = error.localizedDescription
    }
    
    func clearError() {
        errorMessage = nil
    }
}
