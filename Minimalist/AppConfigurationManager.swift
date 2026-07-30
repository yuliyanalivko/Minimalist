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
    private(set) var databaseManager: DatabaseManaging
    
    private(set) var isInitialized = false
    
    init(
        firebaseConfigurator: SDKConfigurator = FirebaseConfigurator(),
        remoteConfigManager: RemoteConfigManaging = RemoteConfigManager(),
        notificationManager: NotificationManaging = NotificationManager.shared,
        databaseManager: DatabaseManaging = DatabaseManager()
    ) {
        self.firebaseConfigurator = firebaseConfigurator
        self.remoteConfigManager = remoteConfigManager
        self.notificationManager = notificationManager
        self.databaseManager = databaseManager
    }
    
    func initializeSDKs() {
        Task { @MainActor in
            await performInitialization()
        }
    }
    
    func updateAnalyticsManagerProviders(_ providers: [AnalyticsTracking]) {
        analyticsManager?.updateProviders(providers)
    }
    
    private func performInitialization() async {
        configureFirebase()
        
        await remoteConfigManager.fetchAndActivate()
        
        await configureAnalytics()
        
        clearCache()
        
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
    
    private func clearCache() {
        let now: Date = Date()
        
        guard let cutoff = Calendar.current.date(byAdding: .day, value: -30, to: now) else {
            return
        }
        
        try? databaseManager.delete(type: CategoryEntity.self, olderThan: cutoff)
        try? databaseManager.delete(type: ItemEntity.self, olderThan: cutoff)
        try? databaseManager.delete(type: ItemDetailsEntity.self, olderThan: cutoff)
    }
}
