import SwiftUI

struct Separator: ViewModifier {
    let alignment: Alignment
    let color: Color
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(color),
                alignment: alignment
            )
    }
}

extension View {
    func separator(_ alignment: Alignment, color: Color = Color.AppColor.backgroundSecondary) -> some View {
        modifier(Separator(alignment: alignment, color: color))
    }
}
