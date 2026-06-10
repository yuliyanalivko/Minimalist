import SwiftUI

struct ItemView: View {
    let item: Item
    
    var onAddToFavoriteTap: () -> Void
    
    private var imageSize: CGFloat {
        UIScreen.main.bounds.width * 0.4
    }
    
    var body: some View {
        HStack {
            ZStack {
                if let imageUrl = item.thumbnailUrl {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .failure:
                            imagePlaceholder
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            ProgressView()
                        }
                    }
                    .aspectRatio(contentMode: .fill)
                } else {
                    imagePlaceholder
                }
            }
            .frame(width: imageSize, height: imageSize)
            .aspectRatio(1, contentMode: .fit)
            .background(Color.AppColor.backgroundSecondary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text(item.name)
                        .font(.AppFont.headline)
                        .textCase(.uppercase)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image.heart
                        .font(.AppFont.icon)
                        .padding(.leading, 4)
                        .foregroundStyle(item.isFavorited ? Color.AppColor.primary : Color.AppColor.backgroundSecondary)
                        .onTapGesture {
                            onAddToFavoriteTap()
                        }
                }
                
                Text(item.subcategory?.name ?? "")
                    .font(.AppFont.caption)
                    .padding(.bottom, 10)

                RatingView(rating: item.rating)
                    .padding(.bottom, 10)
                
                Text("\(item.price, specifier: "%.2f") $")
                    .font(.AppFont.headline)
            }
            .padding(.vertical, 15)
            .padding(.leading, 15)
        }
        .defaultHorizontalScreenPadding()
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
        .listRowSeparator(.hidden)
        .overlay(
            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color.AppColor.backgroundSecondary),
            alignment: .top
        )
        .overlay(
            Rectangle()
                .frame(height: 2)
                .foregroundColor(Color.AppColor.backgroundSecondary),
            alignment: .bottom
        )
    }
    
    private var imagePlaceholder: some View {
        Image.photo
            .font(.largeTitle)
            .foregroundStyle(Color.AppColor.textSecondary)
    }
}

#Preview {
    ItemView(item: Item(
        id: "1",
        name: "Feelsisk Solklint",
        category: Category(
            id: "2",
            name: "Category",
            thumbnailUrl: nil,
            subCategories: []
        ),
        subcategory: SubCategory(
            id: "3",
            name: "SubCategory",
            thumbnailUrl: nil,
            iconName: ""
        ),
        rating: 2.56,
        isFavorited: true,
        isAddedToCart: true,
        price: 45.7643,
        thumbnailUrl:  "https://www.mamp.one/wp-content/uploads/2024/09/image-resources2.jpg"
    ), onAddToFavoriteTap: {})
}
