final class TestingAnalyticsManager: ScreenTracking, EventTracking {
    static let shared = TestingAnalyticsManager()
    
    private init() {}
    
    func trackScreen(_ screenName: String) {
        NotificationManager.shared.showNotification(title: "screen_view", message: screenName)
    }
    
    func logEvent(_ event: FirebaseAnalyticsEvent) {
        NotificationManager.shared.showNotification(title: event.name, message: "\(event.parameters)")
    }
}

