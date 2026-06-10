import FirebaseAnalytics

final class FirebaseAnalyticsProvider: AnalyticsTracking {
    
    private(set) var consumer: AnalyticsTracking

    init(consumer: AnalyticsTracking = Analytics.consumer) {
        self.consumer = consumer
    }

    func logEvent(_ event: AnalyticsEvent) {
        consumer.logEvent(event)
    }
}

extension Analytics {
    static let consumer: AnalyticsTracking = Consumer()
    
    final class Consumer: AnalyticsTracking {
        func logEvent(_ event: AnalyticsEvent) {
            Analytics.logEvent(event.name, parameters: event.parameters)
        }
    }
}
