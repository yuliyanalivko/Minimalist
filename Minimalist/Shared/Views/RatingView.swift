import SwiftUI

struct RatingView: View {
    let viewModel: RatingDataModel
    
    init(viewModel: RatingDataModel) {
        self.viewModel = viewModel
    }
    
    init(rating: Double, isReadOnly: Bool = true, ratingItems: [RatingItem]? = nil) {
        self.viewModel = RatingViewModel(
            rating: rating,
            isReadOnly: isReadOnly,
            ratingItems: ratingItems
        )
    }
    
    var body: some View {
        HStack(spacing: viewModel.spacing) {
            ForEach(Array(viewModel.ratingItems.enumerated()), id: \.offset) { (index, item) in
                let starFill = viewModel.starFill(index)
                
                Image(systemName: item.icon)
                    .resizable()
                    .frame(width: viewModel.itemSize, height: viewModel.itemSize)
                    .foregroundStyle(item.backgroundColor)
                    .overlay(
                        Image(systemName: item.icon)
                            .font(.system(size: viewModel.itemSize))
                            .foregroundStyle(item.highlightedColor)
                            .mask(
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .frame(width: viewModel.maskWidth(starFill: starFill))
                                    if starFill < 1 {
                                        Spacer(minLength: 0)
                                    }
                                }
                            )
                    )
                    .onTapGesture {
                        viewModel.setRating(index)
                    }
            }
        }
    }
    
    private func starRow(filled: Bool) -> some View {
        HStack(spacing: viewModel.spacing) {
            ForEach(0 ..< viewModel.ratingItems.count, id: \.self) { index in
                let item = viewModel.ratingItems[index]
                
                Image(systemName: item.icon)
                    .resizable()
                    .frame(width: viewModel.itemSize, height: viewModel.itemSize)
                    .foregroundStyle(filled ? item.highlightedColor : item.backgroundColor)
            }
        }
        .clipped()
    }
}

#Preview {
    RatingView(rating: 3.5, isReadOnly: false, ratingItems: [
        RatingItem(
            icon: "heart.fill",
            highlightedColor: Color.red,
            backgroundColor: Color.AppColor.backgroundSecondary
        ),
        RatingItem(
            icon: "sun.min.fill",
            highlightedColor: Color.yellow,
            backgroundColor: Color.AppColor.backgroundSecondary
        ),
        RatingItem(
            icon: "leaf.fill",
            highlightedColor: Color.green,
            backgroundColor: Color.AppColor.backgroundSecondary
        ),
        RatingItem(
            icon: "cloud.rain.fill",
            highlightedColor: Color.blue,
            backgroundColor: Color.AppColor.backgroundSecondary
        ),
        RatingItem(
            icon: "pawprint.fill",
            highlightedColor: Color.purple,
            backgroundColor: Color.AppColor.backgroundSecondary
        )
    ])
}
