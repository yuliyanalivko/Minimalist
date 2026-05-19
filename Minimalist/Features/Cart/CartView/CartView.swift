import SwiftUI

struct CartView: View {
    @State var router = CartRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            screen(for: .cart)
                .navigationDestination(for: CartRoute.self) { route in
                    screen(for: route)
                }
        }
        .environment(router)
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
    CartView()
}
