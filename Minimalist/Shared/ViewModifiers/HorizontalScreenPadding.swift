import SwiftUI

struct HorizontalScreenPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
    }
}

extension View {
    func horizontalScreenPadding() -> some View {
        modifier(HorizontalScreenPadding())
    }
}
