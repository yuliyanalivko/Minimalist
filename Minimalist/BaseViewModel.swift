import SwiftUI

@Observable class BaseViewModel {
    var isLoading: Bool = false
    var error: AppError?
    
    var errorMessage: String? {
        error?.message
    }
    
    /// Sets the current error state for the view model.
    ///
    /// This method is used to store an error that occurred during an
    /// operation (e.g. network request, or business logic failure).
    ///
    /// The UI layer is expected to observe `errorMessage`  and
    /// present an appropriate user-facing message.
    ///
    /// - Parameter error: An AppError representing the failure state.
    func setError(_ error: AppError) {
        self.error = error
    }
    
    func clearError() {
        error = nil
    }
}
