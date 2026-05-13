import SwiftUI

struct CardBorder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.AppColor.backgroundSecondary, lineWidth: 2.5)
            )
    }
}

extension View {
    func cardBorder() -> some View {
        modifier(CardBorder())
    }
}
