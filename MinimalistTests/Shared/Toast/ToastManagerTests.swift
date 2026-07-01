import Testing
@testable import Minimalist

struct ToastManagerTests {
    
    @MainActor
    @Test("Should show toast")
    func show_setsCurrentToast() {
        let manager = ToastManager()
        manager.show(message: "Successed", style: .success)
        
        #expect(manager.current?.message == "Successed")
        #expect(manager.current?.style == .success)
    }
    
    @MainActor
    @Test("Should add toast to the queue")
    func show_addToastToQueue() {
        let manager = ToastManager()
        manager.show(message: "Successed", style: .success)
        manager.show(message: "Failed", style: .error)
        
        #expect(manager.current?.message == "Successed")
        #expect(manager.queue.count == 1)
        #expect(manager.queue.first?.message == "Failed")
        #expect(manager.queue.first?.style == .error)
    }
}
