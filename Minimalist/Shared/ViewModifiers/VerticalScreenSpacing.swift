import SwiftUI

struct VerticalScreenSpacing: ViewModifier {
    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 20)
            }
    }
}

extension View {
    func verticalScreenSpacing() -> some View {
        modifier(VerticalScreenSpacing())
    }
}
