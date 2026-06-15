import SwiftUI

@Observable
class RatingViewModel: RatingDataModel {
    var rating: Double = 0
    var isReadOnly: Bool = true
    var items: [SelectableListItemRepresentable]
    
    let itemSize: CGFloat = 17
    
    init(
        rating: Double = 0,
        isReadOnly: Bool = true,
        items: [SelectableListItemRepresentable]? = nil
    ) {
        self.rating = rating
        self.isReadOnly = isReadOnly
        
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
            rating = Double(index + 1)
        }
    }
}
