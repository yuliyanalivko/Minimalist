import SwiftUI

struct ToastModifier: ViewModifier {
    let manager: ToastManager = ToastManager.shared
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                Group {
                    if let toast = manager.current {
                        ToastView(toast: toast)
                            .id(toast.id)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .onTapGesture {
                                manager.dismissCurrent()
                            }
                    }
                }
                .animation(.easeInOut(duration: manager.animationDurationInSec), value: manager.current?.id)
            }
    }
}

extension View {
    func toast() -> some View {
        self.modifier(ToastModifier())
    }
}
