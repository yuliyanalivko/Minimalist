import SwiftUI

struct RatingView: View {
    @State private var viewModel: RatingViewModel

    init(viewModel: RatingViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    init(
        rating: Double
    ) {
        _viewModel = State(
            initialValue: RatingViewModel(
                rating: rating
            )
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
    let vm = RatingViewModel(rating: 3.5, isReadOnly: false, ratingItems: [
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
    RatingView(viewModel: vm)
}
