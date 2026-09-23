import Foundation
import UserNotifications

protocol NotificationCenterProtocol: AnyObject {
    var delegate: UNUserNotificationCenterDelegate? { get set }
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    func add(_ request: UNNotificationRequest) async throws
    func removePendingNotificationRequests(withIdentifiers identifiers: [String])
}

extension UNUserNotificationCenter: NotificationCenterProtocol {}

protocol NotificationManaging {
    func requestAuthorization() async -> Bool
    func showNotification(title: String, message: String?, timeInterval: Double) -> String
    func cancelSheduledNotification(withIdentifier identifier: String)
}

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate, NotificationManaging {
    static let shared = NotificationManager()
    
    private let notificationCenter: NotificationCenterProtocol
    
    init(center: NotificationCenterProtocol = UNUserNotificationCenter.current()) {
        notificationCenter = center
        super.init()
        notificationCenter.delegate = self
    }
    
    /// Requests the user's permission to display local notifications.
    /// - Returns: A boolean value indicating whether the authorization was successfully granted.
    func requestAuthorization() async -> Bool {
        (try? await notificationCenter.requestAuthorization(options: [.alert])) ?? false
    }
    
    /// Schedules a local notification to be displayed after a specific time interval.
    /// - Parameters:
    ///   - title: The primary title string displayed at the top of the alert banner.
    ///   - message: An optional subtitle or detailed description body of the notification.
    ///   - timeInterval: The delay in seconds before triggering the notification. Defaults to `0.1`.
    /// - Returns: A unique string identifier representing the newly scheduled notification request.
    @discardableResult
    func showNotification(title: String, message: String?, timeInterval: Double = 0.1) -> String {
        let content = UNMutableNotificationContent()
        content.title = title
        
        if let message = message {
            content.body = message
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let id = UUID().uuidString
        
        let request = UNNotificationRequest(
            identifier: id,
            content: content,
            trigger: trigger
        )
        
        Task {
            try? await notificationCenter.add(request)
        }
        
        return id
    }
    
    /// Cancels a specific pending notification that has been scheduled but not yet delivered.
    /// - Parameter identifier: The unique string ID associated with the notification request to be removed.
    func cancelSheduledNotification(withIdentifier identifier: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    /// Asks the delegate how to handle a notification that arrived while the app was running in the foreground.
    /// - Parameters:
    ///   - center: The notification center that received the alert.
    ///   - notification: The system notification payload object containing content and triggers.
    ///   - completionHandler: A block closure that defines the desired behavior, configured here to present a `.banner`.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner])
    }
}
