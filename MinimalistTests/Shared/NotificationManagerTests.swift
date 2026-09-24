import Testing
import UserNotifications
@testable import Minimalist

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
    
    @Test("Should correctly format and schedule a notification request with a 0.1 sec delay")
    func showNotification_withLittleDelay() async throws {
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
    
    @Test("Should correctly format and schedule a notification request with a specified delay and cancel it")
    func showNotification_withSpecifiedDelay_and_cancelSheduledNotification() async throws {
        let mockCenter = MockNotificationCenter()
        let manager = NotificationManager(center: mockCenter)
        let expectedTitle = "Title"
        let expectedMessage = "Message"
        
        let id = manager.showNotification(title: expectedTitle, message: expectedMessage, timeInterval: 2)
        
        try await Task.sleep(nanoseconds: 10_000_000)
        
        guard let request = mockCenter.addedRequests.first else {
            Issue.record("Expected a notification request to be added")
            
            return
        }
        
        #expect(request.content.title == expectedTitle)
        #expect(request.content.body == expectedMessage)
        
        let trigger = try #require(request.trigger as? UNTimeIntervalNotificationTrigger)
        #expect(trigger.timeInterval == 2)
        #expect(trigger.repeats == false)
        #expect(mockCenter.addedRequests[0].identifier == id)
        
        manager.cancelSheduledNotification(withIdentifier: id)
        
        #expect(mockCenter.addedRequests == [])
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
