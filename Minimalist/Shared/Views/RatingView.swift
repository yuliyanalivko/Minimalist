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
        HStack(spacing: 4) {
            ForEach(Array(viewModel.ratingItems.enumerated()), id: \.offset) { (index, item) in
                let starFill = viewModel.starFill(index)
                
                Image(systemName: item.icon)
                    .resizable()
                    .frame(width: viewModel.itemSize, height: viewModel.itemSize)
                    .foregroundStyle(item.backgroundColor)
                    .overlay(
                        Image(systemName: item.icon)
                            .resizable()
                            .frame(width: viewModel.itemSize, height: viewModel.itemSize)
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
}

#Preview {
    RatingView(rating: 3.5, isReadOnly: false, ratingItems: [
        RatingItem(
            icon: "heart.fill",
            highlightedColor: .red,
            backgroundColor: .gray
        ),
        RatingItem(
            icon: "sun.min.fill",
            highlightedColor: .yellow,
            backgroundColor: .gray
        ),
        RatingItem(
            icon: "leaf.fill",
            highlightedColor: .green,
            backgroundColor: .gray
        ),
        RatingItem(
            icon: "cloud.rain.fill",
            highlightedColor: .blue,
            backgroundColor: .gray
        ),
        RatingItem(
            icon: "pawprint.fill",
            highlightedColor: .purple,
            backgroundColor: .gray
        )
    ])
}
