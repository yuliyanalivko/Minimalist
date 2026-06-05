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

@MainActor
final class AppConfigurationManager: ObservableObject {
  
    @Published private(set) var isInitialized = false

    static let shared = AppConfigurationManager()
    
    var firebaseConfigurator: SDKConfigurator = FirebaseConfigurator()
    
    private(set) var analyticsManager: AnalyticsManager?
    
    private init() {}
    
    func initializeSDKs() async {
        Task {
            await performInitialization()
        }
    }
    
    func updateAnalyticsManagerProviders(_ providers: [AnalyticsTracking]) {
        analyticsManager?.updateProviders(providers)
    }
    
    private nonisolated func performInitialization() async {
        await MainActor.run {
            configureFirebase()
        }
        
        await RemoteConfigManager.shared.fetchAndActivate()
        
        await configureAnalytics()
        
        await setIsInitialized(true)
    }
    
    @MainActor
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
    
#if DEBUG
    func resetForTesting() {
        isInitialized = false
        analyticsManager = nil
    }
#endif
}
