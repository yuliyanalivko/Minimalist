import SwiftUI

@Observable
class ItemDetailsViewModel: BaseViewModel {
    var itemDetails: ItemDetails
    
    init(id: String) {
        // TODO: remove later
        self.itemDetails = Self.loadMock()
    }
    
    init(id: String, analyticsManager: AnalyticsManager) {
        // TODO: remove later
        self.itemDetails = Self.loadMock()
        
        super.init(analyticsManager: analyticsManager)
    }
    
    // TODO: remove later
    static func loadMock() -> ItemDetails {
        let data = itemDetailsMock.data(using: .utf8)!
        do {
            return try JSONDecoder().decode(ItemDetails.self, from: data)
        } catch {
            print("Decode error:", error)
            fatalError("\(error)")
        }
    }
    
    func toggleFavorite() {
        itemDetails.isFavorited.toggle()
        logFavoriteEvent()
    }
    
    func toggleCart() {
        itemDetails.isAddedToCart.toggle()
        logCartEvent()
    }
    
    private func logFavoriteEvent() {
        let eventName: AnalyticsEventName = itemDetails.isFavorited
        ? AnalyticsEventName.addToWishlist
        : AnalyticsEventName.removeFromWishlist
        
        logEvent(AnalyticsEvent(
            name: eventName,
            parameters: [.itemId: itemDetails.id, .itemName: itemDetails.name]
        ))
    }
    
    private func logCartEvent() {
        let eventName: AnalyticsEventName = itemDetails.isAddedToCart
        ? AnalyticsEventName.addToCart
        : AnalyticsEventName.removeFromCart
        
        logEvent(AnalyticsEvent(
            name: eventName,
            parameters: [.itemId: itemDetails.id, .itemName: itemDetails.name]
        ))
    }
}
