import Foundation
import UserNotifications
@testable import Minimalist

final class MockNotificationCenter: NotificationCenterProtocol {
    var delegate: UNUserNotificationCenterDelegate?
    
    private(set) var requestedOptions: UNAuthorizationOptions?
    private(set) var addedRequests: [UNNotificationRequest] = []
    
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        requestedOptions = options
        return true
    }
    
    func add(_ request: UNNotificationRequest) async throws {
        addedRequests.append(request)
    }
    
    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        addedRequests = addedRequests.filter { !identifiers.contains($0.identifier) }
    }
}
