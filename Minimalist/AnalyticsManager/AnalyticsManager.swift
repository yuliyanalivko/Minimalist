final class AnalyticsManager {
    
    static let shared = AnalyticsManager(providers: [
        FirebaseAnalyticsManager.shared
    ])
    
    let providers: [any AnalyticsTracking]
    
    init(providers: [any AnalyticsTracking]) {
        self.providers = providers
    }
    
    func trackScreen(_ screenName: String) {
        providers.forEach({ provider in
            guard let provider = provider as? ScreenTracking else {
                return
            }
            
            provider.trackScreen(screenName)
        })
    }
    
    func logEvent<T: AnalyticsEvent>(_ event: T) {
        providers.forEach({ provider in
            guard let provider = provider as? any EventTracking<T> else {
                return
            }
            
            provider.logEvent(event)
        })
    }
}
