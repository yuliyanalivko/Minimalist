import SwiftUI

protocol RatingDataModel: SelectableListDataModel {
    var rating: Double { get set }
    var isReadOnly: Bool { get }
    var itemSize: CGFloat { get }
}

extension RatingDataModel {
    func itemFill(_ index: Int) -> Double {
        max(0, min(1, rating - Double(index)))
    }
    
    func maskWidth(itemFill: Double) -> CGFloat? {
        itemFill == 1 ? nil : itemSize * itemFill
    }
}
