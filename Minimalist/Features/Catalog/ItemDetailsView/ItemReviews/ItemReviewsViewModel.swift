import SwiftUI

@Observable
class ItemReviewsViewModel: BaseViewModel {
    
    let reviews: [Review]
    
    var selectedIndex: Int = 0
    var isFullViewOpened: Bool = false
    var fullViewContentHeight: CGFloat = 200
    
    init(reviews: [Review]) {
        self.reviews = reviews
    }
    
    var prevButtonOpacity: CGFloat {
        selectedIndex == 0 ? 0.5 : 1
    }
    
    var nextButtonOpacity: CGFloat {
        selectedIndex == reviews.count - 1 ? 0.5 : 1
    }
    
    var isPrevButtonDisabled: Bool {
        selectedIndex == 0
    }
    
    var isNextButtonDisabled: Bool {
        selectedIndex == reviews.count - 1
    }
    
    func handleReviewClick() {
        guard reviews[selectedIndex].message != nil else {
            return
        }
        
        isFullViewOpened = true
    }
    
    func navigateBack() {
        selectedIndex = max(selectedIndex - 1, 0)
    }
    
    func navigateForward() {
        selectedIndex = min(selectedIndex + 1, reviews.count - 1)
    }
}
