import SwiftUI

struct TabBarAwareCentering: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.bottom, 80)
    }
}

extension View {
    func tabBarAwareCentering() -> some View {
        modifier(TabBarAwareCentering())
    }
}
