import SwiftUI

struct ToastView: View {
    let toast: ToastItem
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: toast.style.iconName)
                .foregroundColor(toast.style.color)
            
            Text(toast.message)
                .font(.AppFont.caption)
                .foregroundStyle(Color.AppColor.textPrimary)
                .lineLimit(2)
        }
        .padding(14)
        .background(.ultraThinMaterial, in: Capsule())
        .defaultHorizontalScreenPadding()
    }
}
