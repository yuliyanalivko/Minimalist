import SwiftUI

struct FavoritesView: View {
    @State var viewModel: FavoritesViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.router.path) {
            screen(for: .favorites)
                .navigationDestination(for: FavoritesRoute.self) { route in
                    screen(for: route)
                }
        }
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
    FavoritesView(viewModel: FavoritesViewModel(router: .init()))
}
