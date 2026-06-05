import FirebaseAnalytics

final class FirebaseAnalyticsProvider: AnalyticsTracking {
    static let shared = FirebaseAnalyticsProvider()
    
    private init() {}

    func logEvent(_ event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}

 
