import SwiftUI

@Observable
class SortBySheetViewModel {
    var height: CGFloat = 200
    
    var selectedOption: SortOption?
    var selectedOrder: SortOrder?
    
    let options = SortOption.allCases
    
    init(selectedOption: SortOption? = nil, selectedOrder: SortOrder? = nil) {
        self.selectedOption = selectedOption
        self.selectedOrder = selectedOrder
    }
    
    func updateSelection(order: SortOrder?, option: SortOption) {
        if let order {
            selectedOption = option
            selectedOrder = order
        } else {
            selectedOption = nil
            selectedOrder = nil
        }
    }
    
    func getSelectedOrder(option: SortOption) -> SortOrder? {
        selectedOption == option ? selectedOrder : nil
    }
    
    func updateHeight(_ newHeight: CGFloat) {
        height = newHeight
    }
}
