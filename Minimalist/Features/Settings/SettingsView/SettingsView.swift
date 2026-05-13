import SwiftUI

struct SettingsView: View {
    @State var router = SettingsRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            screen(for: .settings)
                .navigationDestination(for: SettingsRoute.self) { route in
                    screen(for: route)
                }
        }
        .environment(router)
    }
    
    @ViewBuilder
    private func screen(for route: SettingsRoute) -> some View {
        switch route {
        case .settings:
            Text("settings")
                .navigationTitle(SettingsRoute.settings.title)
        }
    }
}

#Preview {
    SettingsView()
}
