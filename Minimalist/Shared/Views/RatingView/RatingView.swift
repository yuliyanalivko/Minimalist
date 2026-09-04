import SwiftUI

struct RatingView: View {
    
    private let viewModel: RatingDataModel
    
    init(viewModel: RatingDataModel, onChange: ((Double) -> Void)? = nil) {
        self.viewModel = viewModel
        self.viewModel.onChange = onChange
    }
    
    init(rating: Double, onChange: ((Double) -> Void)? = nil) {
        self.viewModel = RatingViewModel(rating: rating, onChange: onChange)
    }
    
    var body: some View {
        HStack(spacing: viewModel.itemSpacing) {
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
                        guard !viewModel.isReadOnly else { return }
                        
                        viewModel.select(index)
                        viewModel.notifyChange()
                    }
            }
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    viewModel.updateRating(for: value.location.x)
                }
                .onEnded { _ in
                    viewModel.notifyChange()
                },
            isEnabled: !viewModel.isReadOnly
        )
        .allowsHitTesting(!viewModel.isReadOnly)
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
    RatingView(viewModel: vm) { _ in }
}
