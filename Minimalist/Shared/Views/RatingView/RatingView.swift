import SwiftUI

struct RatingView: View {

    private var viewModel: RatingDataModel
    
    init(viewModel: RatingDataModel) {
        self.viewModel = viewModel
    }
    
    init(rating: Double) {
        self.viewModel = RatingViewModel(rating: rating)
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, item in
                let itemFill = viewModel.itemFill(index)
                
                Image(systemName: item.icon)
                    .resizable()
                    .frame(width: viewModel.itemSize, height: viewModel.itemSize)
                    .foregroundStyle(item.inactiveColor)
                    .overlay(
                        Image(systemName: item.icon)
                            .resizable()
                            .frame(width: viewModel.itemSize, height: viewModel.itemSize)
                            .foregroundStyle(item.highlightedColor)
                            .mask(
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .frame(width: viewModel.maskWidth(itemFill: itemFill))
                                    if itemFill < 1 {
                                        Spacer(minLength: 0)
                                    }
                                }
                            )
                    )
                    .onTapGesture {
                        viewModel.select(index)
                    }
            }
        }
    }
}

#Preview {
    let vm = RatingViewModel(rating: 3.5, isReadOnly: false, items: [
        SelectableListItem(
            icon: "heart.fill",
            highlightedColor: .red,
            inactiveColor: .gray
        ),
        SelectableListItem(
            icon: "sun.min.fill",
            highlightedColor: .yellow,
            inactiveColor: .gray
        ),
        SelectableListItem(
            icon: "leaf.fill",
            highlightedColor: .green,
            inactiveColor: .gray
        ),
        SelectableListItem(
            icon: "cloud.rain.fill",
            highlightedColor: .blue,
            inactiveColor: .gray
        ),
        SelectableListItem(
            icon: "pawprint.fill",
            highlightedColor: .purple,
            inactiveColor: .gray
        )
    ])
    RatingView(viewModel: vm)
}
