import SwiftUI
import FirebaseRemoteConfig
import Firebase
import Combine

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

@Observable
final class AppConfigurationManager {
    
    static let shared = AppConfigurationManager()
    
    var firebaseConfigurator: SDKConfigurator = FirebaseConfigurator()
    
    private(set) var analyticsManager: AnalyticsManager?
    
    private(set) var isInitialized = false    
    
    init() {}
    
    func initializeSDKs() async {
        Task { @MainActor in
            await performInitialization()
        }
    }
    
    func updateAnalyticsManagerProviders(_ providers: [AnalyticsTracking]) {
        analyticsManager?.updateProviders(providers)
    }
    
    private func performInitialization() async {
        configureFirebase()
        
        await RemoteConfigManager.shared.fetchAndActivate()
        
        await configureAnalytics()
        
        setIsInitialized(true)
    }
    
    private func setIsInitialized(_ value: Bool) {
        isInitialized = value
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
