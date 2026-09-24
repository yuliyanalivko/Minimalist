import SwiftUI

struct Badge: View {
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundStyle(Color.AppColor.buttonTextPrimary)
            .font(.AppFont.caption)
            .lineLimit(1)
            .padding(.horizontal, 4)
            .frame(minWidth: 17, maxWidth: 48)
            .frame(height: 17)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.AppColor.primaryFocus)
            )
            .fixedSize()
    }
}
