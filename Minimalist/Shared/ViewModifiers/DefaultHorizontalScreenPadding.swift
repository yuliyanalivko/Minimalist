import SwiftUI

struct DefaultHorizontalScreenPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
    }
}

extension View {
    func defaultHorizontalScreenPadding() -> some View {
        modifier(DefaultHorizontalScreenPadding())
    }
}
