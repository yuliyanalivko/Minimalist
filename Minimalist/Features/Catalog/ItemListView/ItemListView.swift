import SwiftUI

struct ItemListView: View {
    @State var viewModel: ItemListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.displayedItems, id: \.id) { item in
                ItemView(
                    item: item,
                    actions: {
                        Button {
                            Task {
                                await viewModel.toggleFavorite(item)
                            }
                        } label: {
                            Image.heart
                                .font(.AppFont.icon)
                                .padding(.leading, 4)
                                .foregroundStyle(item.isFavorited ? Color.AppColor.primary : Color.AppColor.backgroundSecondary)
                        }
                        .buttonStyle(.plain)
                    }
                )
                .onTapGesture {
                    viewModel.handleItemClick(item: item)
                }
            }
        }
        .sheet(item: $viewModel.activeSheet) { sheet in
            switch sheet {
            case .sort:
                if let sortBySheetViewModel = viewModel.sortBySheetViewModel {
                    SortBySheetView(viewModel: sortBySheetViewModel)
                }
                
            case .filter:
                if let filterBySheetViewModel = viewModel.filterBySheetViewModel {
                    FilterBySheetView(viewModel: filterBySheetViewModel)
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
                    
                case .emptyFilter:
                    ContentUnavailableView {
                        Label("No mathing results", systemImage: "line.3.horizontal.decrease")
                    } description: {
                        Text("Clear the filter and sorting and try again.")
                    }
                    
                default:
                    EmptyView()
                }
            }
                .tabBarAwareCentering()
        )
        .listStyle(.plain)
        .verticalScreenSpacing()
        .toolbar {
            Button(action: viewModel.triggerSortBySheet) {
                Image.sort
            }
            Button(action: viewModel.triggerFilterSheet) {
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
