import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let defaultBackgroundColor: Color?
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) private var isFocused: Bool
    @State private var isHovering = false
    
    init(backgroundColor: Color? = nil) {
        self.defaultBackgroundColor = backgroundColor
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(13)
            .frame(minWidth: 200)
            .background(backgroundColor(isPressed: configuration.isPressed))
            .cornerRadius(10)
            .overlay(
                isFocused ? RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.AppColor.primaryFocus, lineWidth: 2) : nil
            )
            .fontWeight(.semibold)
            .textCase(.uppercase)
            .font(.system(size: 17))
            .foregroundStyle(Color.AppColor.buttonTextPrimary)
    }
    
    private func backgroundColor(isPressed: Bool) -> Color {
        guard defaultBackgroundColor == nil else {
            return defaultBackgroundColor!
        }
        
        return isPressed || isHovering ? Color.AppColor.primaryFocus : Color.AppColor.primary.opacity(isEnabled ? 1 : 0.5)
    }
}
