import SwiftUI
import FirebaseRemoteConfig
import Firebase

protocol SDKConfigurator {
    func configure()
}

struct FirebaseConfigurator: SDKConfigurator {
    func configure() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

@MainActor
@Observable
final class AppConfigurationManager {
    
    static let shared = AppConfigurationManager()
    
    var firebaseConfigurator: SDKConfigurator = FirebaseConfigurator()
    
    private(set) var analyticsManager: AnalyticsManager?
    
    private(set) var isInitialized = false
    
    private init() {}
    
    func initializeSDKs() async {
        let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        
        guard !isPreview else {
            self.isInitialized = true
            return
        }
        configureFirebase()
        
        await RemoteConfigManager.shared.fetchAndActivate()
        
        await configureAnalytics()        
        
        self.isInitialized = true
    }
    
    func updateAnalyticsManagerProviders(_ providers: [AnalyticsTracking]) {
        analyticsManager?.updateProviders(providers)
    }
    
    private func configureFirebase() {
        firebaseConfigurator.configure()
    }
    
    private func configureAnalytics() async {
        var providers: [AnalyticsTracking] = [FirebaseAnalyticsProvider.shared]
#if DEBUG
        let isTestingNotificationsEnabled = RemoteConfigManager.shared.isTestingNotificationsEnabled
        let isNotificationsEnabled = await NotificationManager.shared.requestAuthorization()
        
        if isTestingNotificationsEnabled && isNotificationsEnabled {
            providers.append(TestingAnalyticsProvider.shared)
        }
#endif
        analyticsManager = AnalyticsManager(providers: providers)
    }
}
