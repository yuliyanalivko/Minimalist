import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    let defaultBackgroundColor: Color?
    let minWidth: CGFloat
    let borderColor: Color?

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) private var isFocused: Bool
    
    init(backgroundColor: Color? = nil, minWidth: CGFloat = 200, borderColor: Color? = nil) {
        self.defaultBackgroundColor = backgroundColor
        self.minWidth = minWidth
        self.borderColor = borderColor
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(13)
            .frame(minWidth: minWidth)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .stroke(borderColor ?? .clear, lineWidth: 1)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundColor(isPressed: configuration.isPressed))
                        .stroke(borderColor ?? .clear, lineWidth: 1)
                }
            )
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
        let color = defaultBackgroundColor
        ?? (isPressed ? Color.AppColor.primaryFocus : Color.AppColor.primary)
        
        return color.opacity(isEnabled ? 1 : 0.5)
    }
}
