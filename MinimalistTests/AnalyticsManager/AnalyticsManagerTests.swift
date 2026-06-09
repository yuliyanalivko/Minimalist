import Testing
@testable import Minimalist

@MainActor
struct AnalyticsManagerTests {
    
    @Test("Should set new providers value")
    func updateProviders_setNewValue() {
        let manager = AnalyticsManager(providers: [])
        let provider = FirebaseAnalyticsProvider(consumer: MockAnalyticsConsumer())
        
        manager.updateProviders([provider])
        
        #expect(manager.providers.first as? FirebaseAnalyticsProvider === provider)
        #expect(manager.providers.count == 1)
    }
    
    @Test("Should add new provider when new provider type is unique")
    func addProvider_addNewValue_uniqueType() {
        let manager = AnalyticsManager(providers: [FirebaseAnalyticsProvider(consumer: MockAnalyticsConsumer())])
        let provider = TestingAnalyticsProvider(consumer: MockAnalyticsConsumer())
        
        manager.addProvider(provider)
        
        #expect(manager.providers.count == 2)
    }
    
    @Test("Should not add new provider when the provider with the same type exists")
    func addProvider_ignoreNewProvider_notUniqueType() {
        let manager = AnalyticsManager(providers: [TestingAnalyticsProvider(consumer: MockAnalyticsConsumer())])
        let provider = TestingAnalyticsProvider(consumer: MockAnalyticsConsumer())

        manager.addProvider(provider)
        
        #expect(manager.providers.count == 1)
    }
    
    @Test("Should remove a provider when the provider with the same type exists")
    func removeProvider_updateArray_existedType() {
        let manager = AnalyticsManager(providers: [FirebaseAnalyticsProvider(consumer: MockAnalyticsConsumer())])

        manager.removeProvider(ofType: FirebaseAnalyticsProvider.self)
        
        #expect(manager.providers.count == 0)
    }
    
    @Test("Should not remove a provider when there's no providers with such type")
    func removeProvider_ignore_uniqueType() {
        let manager = AnalyticsManager(providers: [FirebaseAnalyticsProvider(consumer: MockAnalyticsConsumer())])

        manager.removeProvider(ofType: TestingAnalyticsProvider.self)
        
        #expect(manager.providers.count == 1)
    }
    
    @Test("Should log an event to the provider")
    func logEvent_triggerProvider() {
        let analyticsConsumer = MockAnalyticsConsumer()
        let manager = AnalyticsManager(providers: [FirebaseAnalyticsProvider(consumer: analyticsConsumer)])
        let event = AnalyticsEvent(name: .addToCart, parameters: [.itemId: "1", .itemName: "Sofa"])
        
        manager.logEvent(event)
        
        guard let name = analyticsConsumer.loggedEvent?.name,
              let parameters = analyticsConsumer.loggedEvent?.parameters else {
            Issue.record("Expected event parameters and name not to be nil")
            
            return
        }
        
        #expect(name == AnalyticsEventName.addToCart.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == "1")
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == "Sofa")
    }
}
