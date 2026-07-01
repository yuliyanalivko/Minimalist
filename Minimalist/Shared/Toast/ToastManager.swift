import SwiftUI

protocol ToastManaging {
    func show(message: String, style: ToastStyle)
}

@Observable
final class ToastManager: ToastManaging {
    static let shared: ToastManager = ToastManager()
    
    private(set) var current: ToastItem?
    private(set) var queue: [ToastItem] = []

    private var dismissTask: Task<Void, Never>?
    
    func show(
        message: String,
        style: ToastStyle = .info,
    ) {
        let toast = ToastItem(message: message, style: style)
        
        if current == nil {
            present(toast)
        } else {
            queue.append(toast)
        }
    }
    
    private func present(_ toast: ToastItem) {
        current = toast
        
        dismissTask = Task { @MainActor in
            try? await Task.sleep(for: .seconds(3))
            current = nil
            
            if let next = queue.first {
                queue.removeFirst()
                present(next)
            }
        }
    }
}

