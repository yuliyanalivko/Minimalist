import SwiftUI

struct SettingsView: View {
    @State var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.router.path) {
            screen(for: .settings)
                .navigationDestination(for: SettingsRoute.self) { route in
                    screen(for: route)
                }
        }
    }
    
    @ViewBuilder
    private func screen(for route: SettingsRoute) -> some View {
        switch route {
        case .settings:
            settings()
                .navigationTitle(SettingsRoute.settings.title)
            
        case .devTools:
            DeveloperToolsView()
                .navigationTitle(SettingsRoute.devTools.title)
            
        case .storage:
            DataAndStorageView()
                .navigationTitle(SettingsRoute.storage.title)
        }
    }
    
    @ViewBuilder
    private func settings() -> some View {
        List {
            Section("Data & Storage") {
                NavigationLink(value: SettingsRoute.storage) {
                    Label {
                        Text(SettingsRoute.storage.title)
                    } icon: {
                        Image.internaldrive
                            .foregroundStyle(Color.AppColor.primary)
                    }
                }
            }
            
#if DEBUG
            Section("Developer") {
                NavigationLink(value: SettingsRoute.devTools) {
                    Label {
                        Text(SettingsRoute.devTools.title)
                    } icon: {
                        Image.hammer
                            .foregroundStyle(Color.AppColor.primary)
                    }
                }
            }
#endif
        }
        .verticalScreenSpacing()
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(router: .init()))
}
