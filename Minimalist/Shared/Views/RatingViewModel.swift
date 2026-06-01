import SwiftUI

@Observable
class RatingViewModel: RatingDataModel {
    var rating: Double = 0
    var isReadOnly: Bool = true
    
    var ratingItems: [RatingItem]
    
    let itemSize: CGFloat = 17
    
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
                backgroundColor: .gray
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
