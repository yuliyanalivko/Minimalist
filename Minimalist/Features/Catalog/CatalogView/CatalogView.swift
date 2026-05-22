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
        .onAppear{
            //TODO: replace "Catalog" with route title once the base router is ready
            AnalyticsManager.shared.trackScreen("Catalog")
        }
    }
    
    @ViewBuilder
    private func screen(for route: CatalogRoute) -> some View {
        switch route {
        case .category:
            CategoryView(viewModel: viewModel.categoryViewModel)
                .navigationTitle(CatalogRoute.category.title)
                .searchableWithDebounce(text: $viewModel.categorySearchText, action: viewModel.logCategorySearchEvent)
            
        case .itemList:
            ItemListView(viewModel: viewModel.itemListViewModel)
                .navigationTitle(route.title)
                .searchableWithDebounce(text: $viewModel.itemListSearchText, action: viewModel.logItemListSearchEvent)
                .onAppear {
                    viewModel.logViewItemListEvent()
                }
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
