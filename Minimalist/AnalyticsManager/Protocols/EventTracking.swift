protocol EventTracking<Event>: AnalyticsTracking {
    associatedtype Event
    
    func logEvent(_ event: Event)
}

