import SwiftUI

@MainActor
@Observable
final class ToastManager {
    static let shared: ToastManager = ToastManager()
    
    let animationDurationInSec: Double = 0.25
    
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
    
    func dismissCurrent(delay: Duration? = nil) {
        dismissTask?.cancel()
        
        dismissTask = Task {
            if let delay = delay {
                try? await Task.sleep(for: delay)
            }
            
            guard !Task.isCancelled else {
                return
            }
            
            current = nil
            try? await Task.sleep(for: .seconds(animationDurationInSec))
            
            guard !Task.isCancelled, let next = queue.first else {
                return
            }
            
            queue.removeFirst()
            present(next)
        }
    }
    
    private func present(_ toast: ToastItem) {
        current = toast
        dismissCurrent(delay: .seconds(3))
    }
}

