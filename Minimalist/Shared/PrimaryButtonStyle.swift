import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) var isFocused: Bool
    @State private var isHovering = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(13)
            .frame(minWidth: 200)
            .background(backgroundColor(isPressed: configuration.isPressed))
            .cornerRadius(10)
            .overlay(
                isFocused ? RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.primaryFocus, lineWidth: 2) : nil
            )
            .fontWeight(.semibold)
            .textCase(.uppercase)
            .font(.system(size: 17))
            .foregroundStyle(Color.AppColor.buttonTextPrimary)
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        isPressed || isHovering ? Color("primaryFocus") : Color("primary").opacity(isEnabled ? 1 : 0.5)
    }
}
