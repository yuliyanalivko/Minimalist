import SwiftUI

struct RadioButton<Value: Hashable>: View {
    let title: String
    let value: Value
    var isDeselectable: Bool = true
    
    @Binding var selection: Value?
    
    var isSelected: Bool {
        selection == value
    }
    
    var body: some View {
        Button(action: {
            selection = (selection == value && isDeselectable) ? nil : value
        }) {
            HStack(spacing: 12) {
                Text(title)
                    .foregroundStyle(Color.AppColor.textPrimary)
                    .font(.AppFont.body)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .AppColor.primary : .AppColor.textSecondary)
                    .frame(width: 24, height: 24)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
