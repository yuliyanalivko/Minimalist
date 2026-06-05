final class TestingAnalyticsProvider: AnalyticsTracking {
    static let shared = TestingAnalyticsProvider()
    
    private init() {}

    func logEvent(_ event: AnalyticsEvent) {
        let message = event.parameters.map { "\($0)" }
        
        NotificationManager.shared.showNotification(title: event.name, message: message)
    }
}

