import SwiftUI

struct ItemListView: View {
    @State var viewModel: ItemListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.displayedItems, id: \.id) { item in
                ItemView(
                    item: item,
                    onAddToFavoriteTap: {
                        Task {
                            await viewModel.toggleFavorite(item)
                        }
                    }
                )
                .onTapGesture {
                    viewModel.handleItemClick(item: item)
                }
            }
        }
        .sheet(isPresented: $viewModel.showSorting) {
            if let sortBySheetViewModel = viewModel.sortBySheetViewModel {
                SortBySheetView(viewModel: sortBySheetViewModel) { option, order in
                    viewModel.updateSorting(by: option, in: order)
                }
            }
        }
        .overlay(
            Group {
                switch viewModel.state {
                case .emptySearch:
                    ContentUnavailableView.search
                    
                case .loading:
                    ProgressView()
                    
                case .empty:
                    NoDataView()
                    
                default:
                    EmptyView()
                }
            }
                .tabBarAwareCentering()
        )
        .listStyle(.plain)
        .verticalScreenSpacing()
        .toolbar {
            Button {
                viewModel.triggerSortBySheet()
            } label: {
                Image.sort
            }
            Button {
            } label: {
                Image.filter
            }
        }
        .task {
            await viewModel.fetchItems()
        }
        .refreshable {
            await viewModel.fetchItems()
        }
    }
}

#Preview {
    ItemListView(viewModel: ItemListViewModel(categoryId: "1", router: CatalogRouter()))
}
