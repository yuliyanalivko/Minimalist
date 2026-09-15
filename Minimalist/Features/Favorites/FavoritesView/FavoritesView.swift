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
        .onAppear{
            viewModel.trackFavoritesScreen()
        }
    }
    
    @ViewBuilder
    private func screen(for route: FavoritesRoute) -> some View {
        switch route {
        case .favorites:
            FavoriteListView(viewModel: viewModel.favoriteListViewModel)
                .navigationTitle(FavoritesRoute.favorites.title)
                .searchableWithDebounce(text: $viewModel.favoriteListViewModel.searchText, action: viewModel.logFavoriteListSearchEvent)
            
        case .itemDetails(_, let id):
            ItemDetailsView(id: id)
                .navigationTitle(route.title)
        }
    }
}

#Preview {
    FavoritesView(viewModel: FavoritesViewModel(router: .init()))
}
