import SwiftUI

struct FavoritesView: View {
    @State var router = FavoritesRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            screen(for: .favorites)
                .navigationDestination(for: FavoritesRoute.self) { route in
                    screen(for: route)
                }
        }
        .environment(router)
    }
    
    @ViewBuilder
    private func screen(for route: FavoritesRoute) -> some View {
        switch route {
        case .favorites:
            Text("favorites")
                .navigationTitle(FavoritesRoute.favorites.title)
        }
    }
}

#Preview {
    FavoritesView()
}
