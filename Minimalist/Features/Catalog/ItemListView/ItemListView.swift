import SwiftUI

struct ItemListView: View {
    let viewModel: ItemListViewModel
    
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
        .task {
            await viewModel.fetchItems()
        }
        .refreshable {
            await viewModel.fetchItems()
        }
    }
}

#Preview {
    ItemListView(viewModel: ItemListViewModel(id: "1", router: CatalogRouter()))
}
