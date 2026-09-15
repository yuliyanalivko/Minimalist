import SwiftUI

struct TextFieldControl: View {
    @Binding var value: String
    
    var placeholder: String = "Enter"
    var isNumeric: Bool = false
    var validationState: ValidationState? = nil
    var onLostFocus: (() -> Void)? = nil
    
    @FocusState private var isFocused: Bool
    
    private var isValidated: Bool {
        validationState != nil
    }
    
    private var isValid: Bool {
        validationState == .valid
    }
    
    private var color: Color {
        guard isValidated else {
            return .AppColor.backgroundSecondary
        }
        
        return isValid ? .AppColor.success : .AppColor.error
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField(placeholder, text: $value)
                    .font(.AppFont.inputText)
                    .foregroundStyle(Color.AppColor.textPrimary)
                    .textFieldStyle(.plain)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                //                    .focused($isFocused)
                    .keyboardType(isNumeric ? .numberPad : .default)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .focused($isFocused)
                
                postfix
                    .padding(.trailing, 20)
            }
            .overlay(
                Rectangle()
                    .fill(color)
                    .frame(height: 1),
                alignment: .bottom
            )
            .onChange(of: isFocused) { _, focused in
                if !focused {
                    onLostFocus?()
                }
            }
            
            if case .invalid(let errorMessage) = validationState {
                Text(errorMessage)
                    .font(.AppFont.caption)
                    .foregroundStyle(Color.AppColor.error)
                    .padding(.horizontal, 20)
            }
        }
    }
    
    @ViewBuilder
    var postfix: some View {
        if isValidated {
            Image(
                systemName: isValid
                ? AppIcon.checkmark.rawValue
                : AppIcon.xmarkCircleFill.rawValue
            )
            .foregroundStyle(isValid ? Color.AppColor.success : Color.AppColor.error)
            .font(.AppFont.headline)
        }
    }
    
    //    private func validate() {
    //        for validator in validators where validator(value) != .valid {
    //            validationState = validator(value)
    //
    //            return
    //        }
    //
    //        validationState = .valid
    //    }
}

#Preview {
    @Previewable @State var name: String = "Text"
    
    TextFieldControl(value: $name, placeholder: "Enter the name")
}
