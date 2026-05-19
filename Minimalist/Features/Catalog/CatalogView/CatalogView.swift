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
                    text: $viewModel.categoryViewModel.categorySearchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search"
                )
            
        case .subcategory:
            SubCategoryView(viewModel: viewModel.categoryViewModel)
                .navigationTitle(route.title)
                .searchable(
                    text: $viewModel.categoryViewModel.subCategorySearchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search"
                )
            
        case .itemList:
            ItemListView(viewModel: viewModel.itemListViewModel)
                .navigationTitle(route.title)
                .searchable(
                    text: $viewModel.itemListViewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search"
                )
                .toolbar {
                    //TODO: move to a separate view
                    Button {
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    Button {
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
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
