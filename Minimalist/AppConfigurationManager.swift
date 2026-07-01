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
    
    private(set) var firebaseConfigurator: SDKConfigurator
    private(set) var remoteConfigManager: RemoteConfigManaging
    private(set) var notificationManager: NotificationManaging
    private(set) var analyticsManager: AnalyticsManager?
    private(set) var serviceLocator: ServiceLocating
    
    private(set) var isInitialized = false
    
    init(
        firebaseConfigurator: SDKConfigurator = FirebaseConfigurator(),
        remoteConfigManager: RemoteConfigManaging = RemoteConfigManager(),
        notificationManager: NotificationManaging = NotificationManager.shared,
        serviceLocator: ServiceLocating = ServiceLocator.shared
    ) {
        self.firebaseConfigurator = firebaseConfigurator
        self.remoteConfigManager = remoteConfigManager
        self.notificationManager = notificationManager
        self.serviceLocator = serviceLocator
    }
    
    func initializeSDKs() {
        Task { @MainActor in
            await performInitialization()
        }
    }
    
    func updateAnalyticsManagerProviders(_ providers: [AnalyticsTracking]) {
        analyticsManager?.updateProviders(providers)
    }
    
    func registerServices() {
        do {
            try serviceLocator.register(service: CategoryService() as CategoryProviding)
        } catch {
            print("\(error)")
        }
    }
    
    private func performInitialization() async {
        configureFirebase()
        
        await remoteConfigManager.fetchAndActivate()
        
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
        var providers: [AnalyticsTracking] = [FirebaseAnalyticsProvider()]
#if DEBUG
        let isTestingNotificationsEnabled = remoteConfigManager.isTestingNotificationsEnabled
        let isNotificationsEnabled = await notificationManager.requestAuthorization()
        
        if isTestingNotificationsEnabled && isNotificationsEnabled {
            providers.append(TestingAnalyticsProvider())
        }
#endif
        analyticsManager = AnalyticsManager(providers: providers)
    }
}
