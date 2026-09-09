import SwiftUI

@Observable
class RatingViewModel: RatingDataModel {
    var rating: Double = 0
    var isReadOnly: Bool = true
    var items: [SelectableListItemRepresentable]
    
    let itemSize: CGFloat
    let itemSpacing: CGFloat
    
    var onChange: ((Double) -> Void)?
    
    init(
        rating: Double = 0,
        isReadOnly: Bool = true,
        items: [SelectableListItemRepresentable]? = nil,
        itemSize: CGFloat = 17,
        itemSpacing: CGFloat = 4,
        onChange: ((Double) -> Void)? = nil
    ) {
        self.rating = rating
        self.isReadOnly = isReadOnly
        self.itemSize = itemSize
        self.itemSpacing = itemSpacing
        self.onChange = onChange
        
        self.items = items ?? Array(
            repeating: SelectableListItem(
                icon: "star.fill",
                highlightedColor: Color.AppColor.accent,
                inactiveColor: Color.AppColor.backgroundSecondary
            ),
            count: 5
        )
    }
    
    func select(_ index: Int) {
        if !isReadOnly {
            let newRating = Double(index + 1)
            rating = rating == newRating ? 0 : newRating
        }
    }
    
    func updateRating(for xPosition: CGFloat) {
        guard !isReadOnly else {
            return
        }
        
        rating = rating(for: xPosition)
    }
    
    func notifyChange() {
        guard !isReadOnly else {
            return
        }
        
        onChange?(rating)
    }
}
