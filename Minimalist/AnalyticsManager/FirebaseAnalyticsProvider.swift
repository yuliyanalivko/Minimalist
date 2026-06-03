import FirebaseAnalytics

final class FirebaseAnalyticsProvider: ScreenTracking, EventTracking {
    static let shared = FirebaseAnalyticsProvider()
    
    private init() {}
    
    func trackScreen(_ screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName
        ])
    }
    
    func logEvent(_ event: any FirebaseAnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}

 
