import SwiftUI

struct ItemListView: View {
    let viewModel: ItemListViewModel
    
    @State var showSorting: Bool = false
    
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
        .sheet(isPresented: $showSorting) {
            SortBySheetView(
                sortOption: viewModel.sortOption,
                sortOrder: viewModel.sortOrder
            ) { option, order in
                viewModel.updateSorting(by: option, in: order)
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
                showSorting = true
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
