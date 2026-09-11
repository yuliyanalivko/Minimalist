import SwiftUI

struct FavoriteListView: View {
    var viewModel: FavoriteListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.displayedItems, id: \.id) { item in
                ItemView(
                    item: item,
                    actions: {
                        Button {
                            Task {
                                await viewModel.toggleCart(item: item)
                            }
                        } label: {
                            Image.cart
                                .font(.AppFont.icon)
                                .padding(.leading, 4)
                                .foregroundStyle(item.isAddedToCart ? Color.AppColor.primary : Color.AppColor.backgroundSecondary)
                        }
                        .buttonStyle(.plain)
                    }
                )
                .onTapGesture {
                    viewModel.handleItemClick(item: item)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        Task {
                            await viewModel.removeFromFavorites(item)
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
            await viewModel.fetchFavoriteItems()
        }
        .refreshable {
            await viewModel.fetchFavoriteItems()
        }
    }
}
