import Foundation

@Observable
class DeveloperToolsViewModel {

    func showToast(_ style: ToastStyle = .info) {
        ToastManager.shared.show(message: "This is a description of the toast", style: style)
    }
}
