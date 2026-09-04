import SwiftUI

@Observable
class SortBySheetViewModel {
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
    
    func selectedOrder(for option: SortOption) -> SortOrder? {
        selectedOption == option ? selectedOrder : nil
    }
}
