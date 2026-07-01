@testable import Minimalist

final class MockToastManager: ToastManaging {
    var current: ToastItem?
    
    func show(message: String, style: ToastStyle) {
        current = ToastItem(message: message, style: style)
    }
    
    func reset() {
        current = nil
    }
}
