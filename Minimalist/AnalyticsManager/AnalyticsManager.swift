final class AnalyticsManager {
    
    private(set) var providers: [any AnalyticsTracking]
    
    init(providers: [any AnalyticsTracking]) {
        self.providers = providers
    }
    
    func updateProviders(_ providers: [any AnalyticsTracking]) {
        self.providers = providers
    }
    
    func addProvider(_ provider: any AnalyticsTracking) {
        guard !providers.contains(where: {
            type(of: $0) == type(of: provider)
        }) else {
            return
        }
        
        providers.append(provider)
    }
    
    func removeProvider(ofType providerType: AnalyticsTracking.Type) {
        providers.removeAll { type(of: $0) == providerType }
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
