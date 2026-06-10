import Testing
@testable import Minimalist

struct TestingAnalyticsProviderTests {
 
    @Test("Should call consumer logEvent")
    func logEvent_passToConsumer() {
        let consumer = MockAnalyticsConsumer()
        let provider = TestingAnalyticsProvider(consumer: consumer)
        let event = AnalyticsEvent(name: .addToCart, parameters: [.itemId: "1", .itemName: "Sofa"])
        
        provider.logEvent(event)
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event parameters and name not to be nil")
            
            return
        }
        
        #expect(name == AnalyticsEventName.addToCart.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == "1")
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == "Sofa")
    }
    
}
