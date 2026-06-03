struct RemoteConfigFetchFailed: FirebaseAnalyticsEvent {
    let name: String = FirebaseEventName.remoteConfigFetchFailed
    var parameters: [String : Any]
    
    init(errorMessage: String) {
        parameters = [
            FirebaseParamName.errorMessage: String(errorMessage.prefix(100))
        ]
    }
}
