import SwiftUI

struct SettingsView: View {
    @State var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.router.path) {
            screen(for: .devTools)
                .navigationDestination(for: SettingsRoute.self) { route in
                    screen(for: route)
                }
        }
    }
    
    @ViewBuilder
    private func screen(for route: SettingsRoute) -> some View {
        switch route {
        case .settings:
            Text("settings")
                .navigationTitle(SettingsRoute.settings.title)
            
        case .devTools:
            DeveloperToolsView()
                .navigationTitle(SettingsRoute.settings.title)
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(router: .init()))
}
