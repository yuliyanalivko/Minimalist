@testable import Minimalist

final class MockRemoteConfigManager: RemoteConfigManaging {
    var isTestingNotificationsEnabled: Bool = true
    var isRoundTabBarEnabled: Bool = true
    func fetchAndActivate() {}
}
