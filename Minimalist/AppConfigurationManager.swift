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
        Task {
            await performInitialization()
        }
    }
    
    func updateAnalyticsManagerProviders(_ providers: [AnalyticsTracking]) {
        analyticsManager?.updateProviders(providers)
    }
    
    private nonisolated func performInitialization() async {
        let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
        
        guard !isPreview else {
            await setIsInitialized(false)
            return
        }
        
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
