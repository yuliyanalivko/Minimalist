import SwiftUI

protocol RatingDataModel: SelectableListDataModel, AnyObject {
    var rating: Double { get set }
    var isReadOnly: Bool { get }
    var itemSize: CGFloat { get }
    var itemSpacing: CGFloat { get }
    var onChange: ((Double) -> Void)? { get set }
    
    func updateRating(for xPosition: CGFloat)
    func notifyChange()
}

extension RatingDataModel {
    func itemFill(_ index: Int) -> Double {
        max(0, min(1, rating - Double(index)))
    }
    
    func maskWidth(itemFill: Double) -> CGFloat? {
        itemFill == 1 ? nil : itemSize * itemFill
    }
    
    func rating(for xPosition: CGFloat) -> Double {
        let totalStepWidth = itemSize + itemSpacing
        let resetThreshold: CGFloat = -10
        let maxRating = Double(items.count)
        
        if xPosition < resetThreshold {
            return 0
        }
        
        let calculatedRating = Double((xPosition / totalStepWidth).rounded(.up))
        
        return max(1, min(calculatedRating, maxRating))
    }
}
