import Testing
import Foundation
@testable import Minimalist

struct MockConfigurator: SDKConfigurator {
    func configure() {}
}

@MainActor
struct AppConfigurationManagerTests {
    
    func configurationManager() -> AppConfigurationManager {
        let vm = AppConfigurationManager.shared
        vm.firebaseConfigurator = MockConfigurator()
        
        return vm
    }
    
    @Test("Should ignore SDKs configuration and only updates state on preview")
    func initializeSDKs_preview() async {
        setenv("XCODE_RUNNING_FOR_PREVIEWS", "1", 1)
        let vm = configurationManager()
        
        await vm.initializeSDKs()
        
        #expect(vm.isInitialized == true)
        #expect(vm.analyticsManager == nil)
        
        unsetenv("XCODE_RUNNING_FOR_PREVIEWS")
    }
    
    @Test("Should update analytics manager providers")
    func updateAnalyticsManagerProviders_managerIsSet_setProviders() async {
        let vm = configurationManager()
        
        await vm.initializeSDKs()
        
        struct MockAnalyticsProvider: AnalyticsTracking {}
        
        vm.updateAnalyticsManagerProviders([MockAnalyticsProvider()])
        
        #expect(vm.analyticsManager != nil)
        #expect(vm.analyticsManager?.providers.first is MockAnalyticsProvider)
    }
    
    @Test("Should not update providers when analytics manager is nil")
    func updateAnalyticsManagerProviders_managerNil_ignoreUpdate() {
        let vm = configurationManager()
        
        struct MockAnalyticsProvider: AnalyticsTracking {}

        vm.updateAnalyticsManagerProviders([MockAnalyticsProvider()])
        
        #expect(vm.analyticsManager == nil)
    }
}
