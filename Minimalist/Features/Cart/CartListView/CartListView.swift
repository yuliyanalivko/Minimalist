import SwiftUI

struct CartListView: View {
    var viewModel: CartListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.displayedItems, id: \.id) { item in
                ItemView(item: item)
                .onTapGesture {
                    viewModel.handleItemClick(item: item)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        Task {
                            await viewModel.removeFromCart(item)
                        }
                    } label: {
                        Label("Delete", systemImage: AppIcon.trash.rawValue)
                    }
                    .tint(.AppColor.error)
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
            await viewModel.fetchCartItems()
        }
        .refreshable {
            await viewModel.fetchCartItems()
        }
    }
}

#Preview {
    CartListView(viewModel: .init(router: CartRouter()))
}
