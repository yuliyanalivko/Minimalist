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
    }
    
    @ViewBuilder
    private func screen(for route: CartRoute) -> some View {
        switch route {
        case .cart:
            Text("cart")
                .navigationTitle(CartRoute.cart.title)
        }
    }
}

#Preview {
    CartView(viewModel: CartViewModel(router: .init()))
}
