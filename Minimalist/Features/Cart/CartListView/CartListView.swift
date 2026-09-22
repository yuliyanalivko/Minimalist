import SwiftUI

struct CartListView: View {
    @State var viewModel: CartListViewModel
    
    var body: some View {
        List(selection: $viewModel.selectedIds) {
            ForEach(viewModel.displayedItems, id: \.id) { item in
                listItem(item: item)
                    .tag(item.id)
                    .onTapGesture {
                        viewModel.handleItemClick(item: item)
                    }
                    .onLongPressGesture(minimumDuration: 0.5) {
                        viewModel.handleItemLongPress(item: item)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button {
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
        .verticalScreenSpacing()
        .padding(.bottom, 120)
        .listStyle(.plain)
        .overlay(alignment: .bottom) {
            Group {
                if !viewModel.allItems.isEmpty {
                    footer
                        .tabBarAwareCentering()
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
        .task {
            await viewModel.fetchCartItems()
        }
        .refreshable {
            await viewModel.fetchCartItems()
        }
        .tint(.AppColor.primary)
        .environment(\.editMode, .constant(viewModel.isSelectionMode ? .active : .inactive))
        .animation(.easeInOut, value: viewModel.isSelectionMode)
        .onDisappear {
            viewModel.resetSelection()
        }
    }
    
    @ViewBuilder
    private func listItem(item: Item) -> some View {
        ItemView(item: item)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            .listRowBackground(Color.clear)
    }
    
    @ViewBuilder
    private var footer: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Total:")
                    .textCase(.uppercase)
                
                Spacer()
                
                Text("\(viewModel.totalPrice, specifier: "%.2f") $")
                    .foregroundStyle(Color.AppColor.primary)
            }
            .font(.AppFont.headline)
            .defaultHorizontalScreenPadding()
            
            Button {
                viewModel.handleBuyButtonClick()
            } label: {
                Text("Buy")
                    .frame(maxWidth: .infinity)
                    .textCase(.uppercase)
            }
            .buttonStyle(PrimaryButtonStyle())
            .defaultHorizontalScreenPadding()
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
        .separator(.top)
        .background(Color.AppColor.backgroundPrimary)
    }
}

#Preview {
    CartListView(viewModel: .init(router: CartRouter(), cartService: CartService()))
}
