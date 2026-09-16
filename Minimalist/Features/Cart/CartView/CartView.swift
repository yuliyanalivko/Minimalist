import SwiftUI

struct CartView: View {
    @State var viewModel: CartViewModel
    
    var body: some View {
        NavigationStack(path: $viewModel.router.path) {
            screen(for: .cart)
                .navigationDestination(for: CartRoute.self) { route in
                    screen(for: route)
                }
        }
        .onAppear{
            viewModel.trackCartScreen()
        }
    }
    
    @ViewBuilder
    private func screen(for route: CartRoute) -> some View {
        switch route {
        case .cart:
            CartListView(viewModel: viewModel.cartListViewModel)
                .navigationTitle(CartRoute.cart.title)
                .searchableWithDebounce(text: $viewModel.cartListViewModel.searchText, action: viewModel.logCartListSearchEvent)
            
        case .itemDetails(_, let id):
            ItemDetailsView(id: id)
                .navigationTitle(route.title)
        }
    }
}

#Preview {
    CartView(viewModel: CartViewModel(router: .init()))
}
