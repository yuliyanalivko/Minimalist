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

struct MockProviderA: AnalyticsTracking, Equatable {}
struct MockProviderB: AnalyticsTracking, Equatable {}

struct AnalyticsManagerTests {
    
    @Test("Should set new providers value")
    func updateProviders_setNewValue() {
        let manager = AnalyticsManager(providers: [])
        
        let provider = MockProviderA()
        manager.updateProviders([provider])
        
        #expect(manager.providers.first as? MockProviderA == provider)
    }
    
    @Test("Should add new provider when new provider type is unique")
    func addProvider_addNewValue_uniqueType() {
        let manager = AnalyticsManager(providers: [MockProviderA()])
        
        let provider = MockProviderB()
        manager.addProvider(provider)
        
        #expect(manager.providers.count == 2)
    }
    
    @Test("Should not add new provider when the provider with the same type exists")
    func addProvider_ignoreNewProvider_notUniqueType() {
        let manager = AnalyticsManager(providers: [MockProviderA()])
        
        let provider = MockProviderA()
        manager.addProvider(provider)
        
        #expect(manager.providers.count == 1)
    }
    
    @Test("Should remove a provider when the provider with the same type exists")
    func removeProvider_updateArray_existedType() {
        let manager = AnalyticsManager(providers: [MockProviderA()])
        
        manager.removeProvider(ofType: MockProviderA.self)
        
        #expect(manager.providers.count == 0)
    }
    
    @Test("Should not remove a provider when there's no providers with such type")
    func removeProvider_ignore_uniqueType() {
        let manager = AnalyticsManager(providers: [MockProviderA()])
        
        manager.removeProvider(ofType: MockProviderB.self)

        #expect(manager.providers.count == 1)
    }
    
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
        let event = AddToCart(id: "1", name: "Sofa")
        
        manager.logEvent(event)
        
        guard let event = firebaseEvetTrackerMock.loggedEvent as? AddToCart else {
            Issue.record("Expected the first logged event to be AddToCart")
            
            return
        }
        
        #expect(event.name == FirebaseEventName.addToCart)
        #expect(event.parameters[FirebaseParamName.itemId] as? String == "1")
        #expect(event.parameters[FirebaseParamName.itemName] as? String == "Sofa")
        
        #expect(stringEventTrackerMock.loggedEvent == nil)
    }
}
