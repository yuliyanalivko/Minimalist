struct AnalyticsEvent {
    let name: String
    let parameters: [String: Any]?
    
    init(name: AnalyticsEventName, parameters: [AnalyticsParamName: Any]? = nil) {
        self.name = name.rawValue
        
        guard let parameters = parameters else {
            self.parameters = nil
            
            return
        }
        
        var dict: [String: Any] = [:]
        
        for (key, value) in parameters {
            dict[key.rawValue] = value
        }
        
        self.parameters = dict
    }
}
