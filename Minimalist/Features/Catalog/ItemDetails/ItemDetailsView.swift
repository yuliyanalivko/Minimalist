import SwiftUI

struct ItemDetailsView: View {
    let id: String
    
    @State private var viewModel: ItemDetailsViewModel
    
    private var item: ItemDetails {
        viewModel.itemDetails
    }
    
    init(id: String) {
        self.id = id
        _viewModel = State(initialValue: ItemDetailsViewModel(id: id))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ItemImageCarouselView(urls: item.thumbnails)
                    
                    Group {
                        itemDescription
                            .padding(.top, 25)
                        
                        Divider()
                            .padding(.vertical, 30)
                    }
                    .defaultHorizontalScreenPadding()
                    .padding(.horizontal, 10)
                    
                    if let reviews = item.reviews {
                        ItemReviewsView(reviews: reviews)
                    }
                }
            }
            .padding(.bottom, 70)
            
            VStack {
                Spacer()
                
                Button {
                    viewModel.toggleCart()
                } label: {
                    Text(viewModel.itemDetails.isAddedToCart ? "Remove from the cart" : "Buy")
                        .frame(maxWidth: .infinity)
                        .textCase(.uppercase)
                }
                .buttonStyle(PrimaryButtonStyle(color: viewModel.itemDetails.isAddedToCart ? .AppColor.textSecondary : nil))
                .defaultHorizontalScreenPadding()
                .padding(.bottom, 90)
            }
        }
        .verticalScreenSpacing()
    }
    
    private var itemDescription: some View {
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
