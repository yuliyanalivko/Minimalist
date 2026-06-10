final class TestingAnalyticsProvider: AnalyticsTracking {
    
    private(set) var consumer: AnalyticsTracking
    
    init(consumer: AnalyticsTracking = NotificationManager()) {
        self.consumer = consumer
    }

    func logEvent(_ event: AnalyticsEvent) {
        consumer.logEvent(event)
    }
}

extension NotificationManager: AnalyticsTracking {
    func logEvent(_ event: AnalyticsEvent) {
        let message = event.parameters.map { "\($0)" }
        
        self.showNotification(title: event.name, message: message)
    }
}
