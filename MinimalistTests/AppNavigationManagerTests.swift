import Testing
import Foundation
import UserNotifications
@testable import Minimalist

@Suite("App Configuration Manager Tests", .serialized)
@MainActor
struct AppConfigurationManagerTests {

    func configurationManager() -> AppConfigurationManager {
        let manager = AppConfigurationManager(
            firebaseConfigurator: MockSDKConfigurator(),
            remoteConfigManager: MockRemoteConfigManager(),
            notificationManager: MockNotificationManager()
        )

        return manager
    }

    func waitForInitialization(
        manager: AppConfigurationManager,
        timeoutSeconds: Int = 5
    ) async throws {
        let iterations = timeoutSeconds * 10
        for _ in 0..<iterations {
            if manager.isInitialized { return }
            try await Task.sleep(nanoseconds: 100_000_000)
        }
        Issue.record("Initialization did not complete within \(timeoutSeconds)s")
        #expect(manager.isInitialized)
    }

    @Test("Initial state should have uninitialized manager and no analytics")
    func initialState() {
        let manager = AppConfigurationManager()

        #expect(manager.isInitialized == false)
        #expect(manager.analyticsManager == nil)
    }

    @Test("Should not mark initialized synchronously")
    func initializeSDKs_doesNotCompleteSynchronously() async throws {
        let manager = configurationManager()

        manager.initializeSDKs()

        #expect(manager.isInitialized == false)
    }

    @Test("Should configure SDKs and set isInitialized to true")
    func initializeSDKs_configuresSDKsAndCompletes() async throws {
        let manager = configurationManager()

        manager.initializeSDKs()
        try await waitForInitialization(manager: manager)

        #expect(manager.isInitialized == true)
        #expect(manager.analyticsManager != nil)
        
        let providers = manager.analyticsManager?.providers ?? []
        
        #expect(!providers.isEmpty)
        #expect(providers.first is FirebaseAnalyticsProvider)
    }

    @Test("Should do nothing when analytics manager is nil")
    func updateAnalyticsManagerProviders_whenManagerNil_doesNothing() {
        let manager = AppConfigurationManager()

        manager.updateAnalyticsManagerProviders([FirebaseAnalyticsProvider(consumer: MockAnalyticsConsumer())])

        #expect(manager.analyticsManager == nil)
    }

    @Test("Should replace providers when manager exists")
    func updateAnalyticsManagerProviders_whenManagerExists_replacesProviders() async throws {
        let manager = configurationManager()

        manager.initializeSDKs()
        try await waitForInitialization(manager: manager)

        manager.updateAnalyticsManagerProviders([FirebaseAnalyticsProvider(consumer: MockAnalyticsConsumer())])

        #expect(manager.analyticsManager != nil)
        #expect(manager.analyticsManager?.providers.count == 1)
        #expect(manager.analyticsManager?.providers.first is FirebaseAnalyticsProvider)
    }
}
