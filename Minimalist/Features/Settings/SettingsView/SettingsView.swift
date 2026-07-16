import SwiftUI

struct SettingsView: View {
    @State var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.router.path) {
            screen(for: .settings)
                .navigationDestination(for: SettingsRoute.self) { route in
#if DEBUG
                    screen(for: .devTools)
#else
                    screen(for: route)
#endif
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
                .navigationTitle(SettingsRoute.devTools.title)
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(router: .init()))
}
