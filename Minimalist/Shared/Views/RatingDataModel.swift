import SwiftUI

protocol RatingDataModel {
    var rating: Double { get set }
    var isReadOnly: Bool { get }
    var ratingItems: [RatingItem] { get }
    var itemSize: CGFloat { get }
    var spacing: CGFloat { get }
    
    func setRating(_ ratingItemIndex: Int) 
}

extension RatingDataModel {
    func starFill(_ index: Int) -> Double {
        max(0, min(1, rating - Double(index)))
    }
    
    func maskWidth(starFill: Double) -> CGFloat? {
        starFill == 1 ? nil : (itemSize + spacing) * starFill
    }
}
