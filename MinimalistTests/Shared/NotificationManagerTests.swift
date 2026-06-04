import Testing
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
}

@MainActor
struct NotificationManagerTests {
    
    @Test("It sets itself as the notification center delegate on init")
    func testInitializationSetsDelegate() {
        let mockCenter = MockNotificationCenter()
        let manager = NotificationManager(center: mockCenter)
        
        #expect(mockCenter.delegate === manager)
    }
    
    @Test("Should request authorization with the correct alert options")
    func requestAuthorization_withAlertOptions() async {
        let mockCenter = MockNotificationCenter()
        let manager = NotificationManager(center: mockCenter)
        
        await manager.requestAuthorization()
        
        #expect(mockCenter.requestedOptions == [.alert])
    }
    
    @Test("Should correctly format and schedule a notification request")
    func showNotification_scheduleNotification() async throws {
        let mockCenter = MockNotificationCenter()
        let manager = NotificationManager(center: mockCenter)
        let expectedTitle = "Title"
        let expectedMessage = "Message"
        
        manager.showNotification(title: expectedTitle, message: expectedMessage)
        
        try await Task.sleep(nanoseconds: 10_000_000)
        
        guard let request = mockCenter.addedRequests.first else {
            Issue.record("Expected a notification request to be added")
            
            return
        }
        
        #expect(request.content.title == expectedTitle)
        #expect(request.content.body == expectedMessage)
        
        let trigger = try #require(request.trigger as? UNTimeIntervalNotificationTrigger)
        #expect(trigger.timeInterval == 0.1)
        #expect(trigger.repeats == false)
    }
    
    @Test("Should trigger the correct banner presentation options")
    func userNotificationCenter() async {
        let mockCenter = MockNotificationCenter()
        let manager = NotificationManager(center: mockCenter)
        
        let notification = unsafeBitCast(0, to: UNNotification.self)
        
        var capturedOptions: UNNotificationPresentationOptions?
        
        manager.userNotificationCenter(
            UNUserNotificationCenter.current(),
            willPresent: notification
        ) { options in
            capturedOptions = options
        }
        
        #expect(capturedOptions == [.banner])
    }
}
