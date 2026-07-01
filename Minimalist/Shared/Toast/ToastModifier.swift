import SwiftUI

struct ToastModifier: ViewModifier {
    let manager: ToastManager = ToastManager.shared
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                Group {
                    if let toast = manager.current {
                        ToastView(toast: toast)
                            .transition(.move(edge: .top).combined(with: .opacity))
                        
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: manager.current != nil)
            }
    }
}

extension View {
    func toast() -> some View {
        self.modifier(ToastModifier())
    }
}
