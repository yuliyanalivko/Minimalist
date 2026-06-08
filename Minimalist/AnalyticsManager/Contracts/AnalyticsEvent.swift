struct AnalyticsEvent {
    let name: String
    let parameters: [String: Any]?
    
    init(name: AnalyticsEventName, parameters: [AnalyticsParamName: Any]? = nil) {
        self.name = name.rawValue
        self.parameters = parameters.map { dict in
            Dictionary(uniqueKeysWithValues: dict.map { ($0.key.rawValue, $0.value) })
        }
    }
}
