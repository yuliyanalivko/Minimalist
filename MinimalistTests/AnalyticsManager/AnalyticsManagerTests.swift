import Testing
@testable import Minimalist

final class MockScreenTracker: AnalyticsTracking, ScreenTracking {
    var trackedScreenName: String?
    
    func trackScreen(_ screenName: String) {
        trackedScreenName = screenName
    }
}

final class MockEventTracker<ExpectedEvent>: AnalyticsTracking, EventTracking {
    typealias Event = ExpectedEvent
    var loggedEvent: ExpectedEvent?
    
    func logEvent(_ event: ExpectedEvent) {
        loggedEvent = event
    }
}

struct AnalyticsManagerTests {
    
    @Test("Tracking a screen routes to the correct provider")
    func trackScreen_triggerRightProvider() {
        let mockScreenTracker = MockScreenTracker()
        let manager = AnalyticsManager(providers: [mockScreenTracker])
        let expectedScreen = "Home"
        
        manager.trackScreen(expectedScreen)
        
        #expect(mockScreenTracker.trackedScreenName == expectedScreen)
    }
    
    @Test("Logging an event to a matching event provider")
    func logEvent_triggerRightProvider() {
        let firebaseEvetTrackerMock = MockEventTracker<FirebaseAnalyticsEvent>()
        let stringEventTrackerMock = MockEventTracker<String>()
        let manager = AnalyticsManager(providers: [firebaseEvetTrackerMock, stringEventTrackerMock])
        let event = FirebaseAnalyticsEvent.addToCart(id: "1", name: "Sofa")

        manager.logEvent(event)
        
        #expect(firebaseEvetTrackerMock.loggedEvent == event)
        #expect(stringEventTrackerMock.loggedEvent == nil)
    }
}
