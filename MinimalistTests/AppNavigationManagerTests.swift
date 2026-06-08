import Testing
import Foundation
@testable import Minimalist

@Suite("App Configuration Manager Tests", .serialized)
@MainActor
struct AppConfigurationManagerTests {
    
    struct MockConfigurator: SDKConfigurator {
        func configure() {}
    }
    
    struct MockProvider: AnalyticsTracking {
        func logEvent(_ event: AnalyticsEvent) {}
    }
    
    func configurationManager() -> AppConfigurationManager {
        let vm = AppConfigurationManager.shared
        vm.firebaseConfigurator = MockConfigurator()
        
        return vm
    }
    
    func waitForInitialization(vm: AppConfigurationManager, timeout: Int = 5) async throws {
        for _ in 0..<timeout {
            if vm.isInitialized { return }
            try await Task.sleep(nanoseconds: 100_000_000)
        }
        #expect(vm.isInitialized)
    }
    
    @Test("Should configure SDKs and update state")
    func initializeSDKs_updateState() async throws {
        let vm = configurationManager()
        
        await vm.initializeSDKs()
        
        try await waitForInitialization(vm: vm)
        
        #expect(vm.isInitialized == true)
        #expect(vm.analyticsManager != nil)
    }
    
    @Test("Should update analytics manager providers")
    func updateAnalyticsManagerProviders_managerIsSet_setProviders() async throws {
        let vm = configurationManager()
        
        await vm.initializeSDKs()
        
        try await waitForInitialization(vm: vm)
        
        vm.updateAnalyticsManagerProviders([MockProvider()])
        
        #expect(vm.analyticsManager != nil)
        #expect(vm.analyticsManager?.providers.first is MockProvider)
    }
    
    @Test("Should not update providers when analytics manager is nil")
    func updateAnalyticsManagerProviders_managerNil_ignoreUpdate() {
        let vm = AppConfigurationManager()
        
        vm.updateAnalyticsManagerProviders([MockProvider()])
        
        #expect(vm.analyticsManager == nil)
    }
}
