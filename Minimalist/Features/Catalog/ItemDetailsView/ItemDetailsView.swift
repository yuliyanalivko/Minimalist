import SwiftUI

struct ItemDetailsView: View {
    
    @State private var viewModel: ItemDetailsViewModel
    
    init(id: String) {
        _viewModel = State(initialValue: ItemDetailsViewModel(id: id))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
            if case .content(let item) = viewModel.state {
                    ItemImageCarouselView(viewModel: viewModel.itemImageCarouselViewModel)
                    
                    Group {
                        itemDescription(item: item)
                            .padding(.top, 25)
                        
                        Divider()
                            .padding(.vertical, 30)
                    }
                    .defaultHorizontalScreenPadding()
                    .padding(.horizontal, 10)
                    
                    if let reviews = item.reviews, !reviews.isEmpty {
                        ItemReviewsView(viewModel: viewModel.itemReviewsViewModel)
                    }
                }
            }
            .padding(.bottom, 70)
        }
        .overlay(alignment: viewModel.overlayAligment) {
            Group {
                switch viewModel.state {
                case .loading:
                    ProgressView()
                    
                case .empty:
                    NoDataView()
                        .fixedSize()
                    
                case .content(let item):
                    Button {
                        viewModel.toggleCart()
                    } label: {
                        Text(item.isAddedToCart ? "Remove from the cart" : "Buy")
                            .frame(maxWidth: .infinity)
                            .textCase(.uppercase)
                    }
                    .buttonStyle(PrimaryButtonStyle(backgroundColor: item.isAddedToCart ? .AppColor.textSecondary : nil))
                    .defaultHorizontalScreenPadding()
                    .padding(.bottom, 10)
                    
                default:
                    EmptyView()
                }
            }
            .tabBarAwareCentering()
        }
        .verticalScreenSpacing()
        .task {
            await viewModel.fetchItemDetails()
        }
        .refreshable {
            await viewModel.fetchItemDetails()
        }
    }
    
    private func itemDescription(item: ItemDetails) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(item.name)
                    .font(.AppFont.headline)
                    .textCase(.uppercase)
                
                Spacer()
                
                Image.heart
                    .font(.AppFont.icon)
                    .foregroundStyle(item.isFavorited ? Color.AppColor.primary : Color.AppColor.backgroundSecondary)
                    .padding(.trailing, 15)
                    .onTapGesture {
                        viewModel.toggleFavorite()
                    }
                
                Image.cart
                    .font(.AppFont.icon)
                    .foregroundStyle(item.isAddedToCart ? Color.AppColor.primary : Color.AppColor.backgroundSecondary)
                    .onTapGesture {
                        viewModel.toggleCart()
                    }
            }
            
            if let subCategory = item.subCategory {
                Text(subCategory.name)
                    .font(.AppFont.body)
                    .padding(.top, 10)
            }
            
            RatingView(rating: item.rating)
                .padding(.vertical, 20)
            
            Text(item.description)
                .lineSpacing(6)
        }
    }
}

#Preview {
    ItemDetailsView(id: "003479db-a8ec-4d3a-8657-bad7da28d01a")
}
