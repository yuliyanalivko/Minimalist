import Testing
@testable import Minimalist

class MockProviderA: AnalyticsTracking {
    var loggedEvent: AnalyticsEvent?
    
    func logEvent(_ event: AnalyticsEvent) {
        loggedEvent = event
    }
}

class MockProviderB: AnalyticsTracking {
    func logEvent(_ event: AnalyticsEvent) {}
}

struct AnalyticsManagerTests {
    
    @Test("Should set new providers value")
    func updateProviders_setNewValue() {
        let manager = AnalyticsManager(providers: [])
        
        let provider = MockProviderA()
        manager.updateProviders([provider])
        
        #expect(manager.providers.first as? MockProviderA === provider)
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
    
    @Test("SHould log an event to the provider")
    func logEvent_triggerProvider() {
        let provider = MockProviderA()
        let manager = AnalyticsManager(providers: [provider])
        let event = AnalyticsEvent(name: .addToCart, parameters: [.itemId: "1", .itemName: "Sofa"])
        
        manager.logEvent(event)
        
        guard let parameters = event.parameters else {
            Issue.record("Expected parameters not to be nil")
           
            return
        }
        
        #expect(event.name == AnalyticsEventName.addToCart.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == "1")
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == "Sofa")
    }
}
