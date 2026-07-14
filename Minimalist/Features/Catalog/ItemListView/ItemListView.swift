import SwiftUI

struct ItemListView: View {
    let viewModel: ItemListViewModel
    
    var body: some View {
        if !viewModel.displayedItems.isEmpty {
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
            .listStyle(.plain)
            .verticalScreenSpacing()
        } else {
            EmptySearchResultView()
        }
    }
}

#Preview {
    ItemListView(viewModel: ItemListViewModel(router: CatalogRouter()))
}
