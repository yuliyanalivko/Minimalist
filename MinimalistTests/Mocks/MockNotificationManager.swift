@testable import Minimalist

final class MockNotificationManager: NotificationManaging {
    func requestAuthorization() async -> Bool {
        true
    }
}
