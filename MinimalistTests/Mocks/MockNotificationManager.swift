@testable import Minimalist

final class MockNotificationManager: NotificationManaging {
    func requestAuthorization() async -> Bool {
        true
    }    
    
    func showNotification(title: String, message: String?, timeInterval: Double) -> String {
        ""
    }
    
    func cancelSheduledNotification(withIdentifier identifier: String) {}
}
