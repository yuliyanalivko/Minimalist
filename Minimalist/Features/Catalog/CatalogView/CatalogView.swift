import SwiftUI

struct CatalogView: View {
    @State var viewModel: CatalogViewModel = CatalogViewModel()
    
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
            CategoryView(viewModel: viewModel.categoryViewModel)
                .navigationTitle(CatalogRoute.category.title)
                .searchable(
                    text: $viewModel.categorySearchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search"
                )
            
        case .subcategory:
            SubCategoryView(viewModel: viewModel.categoryViewModel)
                .navigationTitle(route.title)
                .searchable(
                    text: $viewModel.subCategorySearchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search"
                )
            
        case .itemList:
            ItemListView(viewModel: viewModel.itemListViewModel)
                .navigationTitle(route.title)
                .searchable(
                    text: $viewModel.itemListSearchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search"
                )
                .toolbar {
                    //TODO: move to a separate view
                    Button {
                    } label: {
                        Image.sort
                    }
                    Button {
                    } label: {
                        Image.filter
                    }
                }
            
        case .itemDetails(_, let id):
            ItemDetailsView(id: id)
                .navigationTitle(route.title)
        }
    }
}

#Preview {
    CatalogView()
}
