protocol EventTracking<Event>: AnalyticsTracking, AnyEventTracking {
    associatedtype Event
    
    func logEvent(_ event: Event)
}

extension EventTracking {
    func tryLog(_ event: any AnalyticsEvent) {
        if let matchedEvent = event as? Event {
            self.logEvent(matchedEvent)
        }
    }
}

protocol AnyEventTracking: AnalyticsTracking {
    func tryLog(_ event: any AnalyticsEvent)
}
