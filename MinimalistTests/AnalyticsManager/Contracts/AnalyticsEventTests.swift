import Testing
@testable import Minimalist

struct AnalyticsEventTests {
    
    @Test("Should set name and map parameters")
    func init_setNameAndParameters() {
        let event = AnalyticsEvent(name: .addToCart, parameters: [.itemId: "1", .itemName: "Sofa"])
        
        guard let parameters = event.parameters else {
            Issue.record("Expected event parameters not to be nil")
            
            return
        }
        
        #expect(event.name == AnalyticsEventName.addToCart.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == "1")
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == "Sofa")
    }
    
    @Test("Should only set name")
    func init_setName_parametersNil() {
        let event = AnalyticsEvent(name: .screenView)
        
        #expect(event.name == AnalyticsEventName.screenView.rawValue)
        #expect(event.parameters == nil)
    }
}
