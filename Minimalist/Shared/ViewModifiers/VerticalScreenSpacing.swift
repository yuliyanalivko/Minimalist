import SwiftUI

struct VerticalScreenSpacing: ViewModifier {
    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 20)
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 100)
            }
    }
}

extension View {
    func verticalScreenSpacing() -> some View {
        modifier(VerticalScreenSpacing())
    }
}
