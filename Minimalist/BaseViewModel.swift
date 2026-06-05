import SwiftUI

@Observable class BaseViewModel {
    var isLoading: Bool = false
    
    private(set) var error: Error?
    
    private let analyticsManager: AnalyticsManager? = AppConfigurationManager.shared.analyticsManager
    
    var errorMessage: String? {
        error?.localizedDescription
    }
    
    /// Sets the current error state for the view model.
    ///
    /// This method is used to store an error that occurred during an
    /// operation (e.g. network request, or business logic failure).
    ///
    /// The UI layer is expected to observe `errorMessage`  and
    /// present an appropriate user-facing message.
    ///
    /// - Parameter error: Error representing the failure state.
    func setError(_ error: Error) {
        self.error = error
    }
    
    func clearError() {
        error = nil
    }
    
    func logEvent(_ event: AnalyticsEvent) {
        analyticsManager?.logEvent(event)
    }
}
