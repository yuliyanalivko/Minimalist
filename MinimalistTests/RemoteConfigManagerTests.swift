import Testing
import Foundation
import Firebase
@testable import Minimalist

@Suite("Remote Config Manager Tests", .serialized)
struct RemoteConfigManagerTests {
    
    @Test(
        "Should match expected Firebase keys",
        arguments: [
            (RemoteConfigManager.ParameterKey.isRoundTabBarEnabled, "is_round_tab_bar_enabled"),
            (RemoteConfigManager.ParameterKey.isTestingNotificationsEnabled, "is_testing_notifications_enabled"),
        ]
    )
    func parameterKeys_matchExpectedRawValues(
        key: RemoteConfigManager.ParameterKey,
        expected: String
    ) {
        #expect(key.rawValue == expected)
    }
    
    @Test("Should expose default values before fetch")
    func initialState_hasExpectedDefaults() {
        let manager = RemoteConfigManager()
        
        #expect(manager.isRoundTabBarEnabled == true)
        #expect(manager.isTestingNotificationsEnabled == false)
    }
    
    @Test("Should complete when Firebase is not configured")
    func fetchAndActivate_withoutFirebase_doesNotCrash() async {
        let manager = RemoteConfigManager(firebaseApp: nil)
        
        await manager.fetchAndActivate()
        
        #expect(manager.isRoundTabBarEnabled == true)
        #expect(manager.isTestingNotificationsEnabled == false)
    }
}
