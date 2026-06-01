import SwiftUI

@Observable
class RatingViewModel: RatingDataModel {
    var rating: Double = 0
    var isReadOnly: Bool = true
    
    var ratingItems: [RatingItem]
    
    let itemSize: CGFloat = 17
    let spacing: CGFloat = 4
    
    init(
        rating: Double = 0,
        isReadOnly: Bool = true,
        ratingItems: [RatingItem]? = nil
    ) {
        self.rating = rating
        self.isReadOnly = isReadOnly
        
        self.ratingItems = ratingItems ?? Array(
            repeating: RatingItem(
                icon: "star.fill",
                highlightedColor: Color.AppColor.accent,
                backgroundColor: Color.AppColor.backgroundSecondary
            ),
            count: 5
        )
    }
    
    func setRating(_ ratingItemIndex: Int) {
        if !isReadOnly {
            rating = Double(ratingItemIndex + 1)
        }
    }
}
