import SwiftUI

struct ItemListView: View {
    let viewModel: ItemListViewModel
    let id: String
    
    var body: some View {
        List {
            ForEach(viewModel.displayedItems, id: \.id) { item in
                ItemView(
                    item: item,
                    onAddToFavoriteTap: {
                        viewModel.toggleFavorite(item)
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
        .task {
            await viewModel.fetchItems(id: id)
        }
        .refreshable {
            await viewModel.fetchItems(id: id)
        }
    }
}

#Preview {
    ItemListView(viewModel: ItemListViewModel(router: CatalogRouter()), id: "1")
}
