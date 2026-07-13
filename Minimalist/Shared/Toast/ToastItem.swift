import SwiftUI

struct ToastItem: Identifiable {
    let id = UUID()
    let message: String
    let style: ToastStyle
    let textColor: Color = .AppColor.textPrimary
    let font: Font = .AppFont.caption
}

enum ToastStyle {
    case success
    case error
    case info
    case warning
    
    var iconName: String {
        switch self {
        case .success: 
            return "checkmark.circle.fill"
        case .error: 
            return "xmark.circle.fill"
        case .info:
            return "info.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .success:
            return .AppColor.success
        case .error:
            return .AppColor.error
        case .info:
            return .AppColor.textPrimary
        case .warning:
            return .AppColor.accent
        }
    }
}
