import SwiftUI

struct CatalogView: View {    
    @State private var viewModel = CatalogViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.router.path) {
            screen(for: .category)
                .navigationDestination(for: CatalogRoute.self) { route in
                    screen(for: route)
                }
        }
        .environment(viewModel.router)
    }
    
    @ViewBuilder
    private func screen(for route: CatalogRoute) -> some View {
        switch route {
        case .category:
            CategoryView(viewModel: viewModel)
                .navigationTitle(CatalogRoute.category.title)
                .searchable(
                    text: $viewModel.categorySearchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search"
                )
            
        case .subcategory:
            SubCategoryView(viewModel: viewModel)
                .navigationTitle(route.title)
                .searchable(
                    text: $viewModel.subCategorySearchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search"
                )
        }
    }
}

#Preview {
    CatalogView()
}
