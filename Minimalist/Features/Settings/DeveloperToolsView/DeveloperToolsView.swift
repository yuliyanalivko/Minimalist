import SwiftUI

struct DeveloperToolsView: View {
    let viewModel: DeveloperToolsViewModel = DeveloperToolsViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            notificationToasts()
            
            Divider()
            
            Spacer()
        }
        .defaultHorizontalScreenPadding()
        .verticalScreenSpacing()
    }
    
    private func notificationToasts() -> some View {
        let toasts: [(title: String, style: ToastStyle, color: Color)] = [
            (title: "Error", style: .error, color: .AppColor.error),
            (title: "Warning", style: .warning, color: .AppColor.accent),
            (title: "Success", style: .success, color: .AppColor.success),
            (title: "Info", style: .info, color: .AppColor.textSecondary)
        ]
        
        return VStack(alignment: .leading, spacing: 20) {
            Text("Notification Toasts")
                .font(.AppFont.appName)
            
            HStack(spacing: 20) {
                ForEach(toasts, id: \.title) { toast in
                    Button("\(toast.title)") {
                        viewModel.showToast(toast.style)
                    }
                    .tint(toast.color)
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    DeveloperToolsView()
}
