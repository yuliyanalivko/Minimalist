final class AnalyticsManager {
    
    static let shared = AnalyticsManager(providers: [
        FirebaseAnalyticsProvider.shared,
        TestingAnalyticsProvider.shared
    ])
    
    let providers: [any AnalyticsTracking]
    
    init(providers: [any AnalyticsTracking]) {
        self.providers = if RemoteConfigManager.shared.isTestingNotificationsEnabled {
            providers + [TestingAnalyticsProvider.shared]
        } else {
            providers
        }
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
        providers.forEach { provider in
            guard let provider = provider as? any AnyEventTracking else {
                return
            }
            provider.tryLog(event)
        }
    }
}
