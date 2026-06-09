@testable import Minimalist

class MockAnalyticsConsumer: AnalyticsTracking {
    var loggedEvent: AnalyticsEvent?
    
    func logEvent(_ event: AnalyticsEvent) {
        loggedEvent = event
    }
}
