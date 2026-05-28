import Testing
import Foundation
import FirebaseAnalytics
@testable import Minimalist

struct FirebaseAnalyticsManagerTests {
    
    @Test("viewItemList event maps fields correctly")
    func viewItemList() {
        let event = FirebaseAnalyticsEvent.viewItemList(
            id: "1",
            name: "Lamps",
        )
        
        #expect(event.name == AnalyticsEventViewItemList)
        #expect(event.parameters[AnalyticsParameterItemListID] as? String == "1")
        #expect(event.parameters[AnalyticsParameterItemListName] as? String == "Lamps")
    }
    
    @Test("viewItem event maps fields correctly")
    func viewItem() {
        let event = FirebaseAnalyticsEvent.viewItem(
            id: "1",
            name: "Vindkast",
            categoryName: "Lamps",
            subCategoryName: "Pendent lamps"
        )
        
        #expect(event.name == AnalyticsEventViewItem)
        #expect(event.parameters[AnalyticsParameterItemListID] as? String == "1")
        #expect(event.parameters[AnalyticsParameterItemListName] as? String == "Vindkast")
        #expect(event.parameters[AnalyticsParameterItemCategory] as? String == "Lamps")
        #expect(event.parameters[AnalyticsParameterItemCategory2] as? String == "Pendent lamps")
    }
    
    @Test("applyFilter event maps fields correctly")
    func applyFilter() {
        let event = FirebaseAnalyticsEvent.applyFilter(
            filters: [
                .price: 49.99,
                .rating: 4.5
            ],
            categoryName: "Lamps"
        )
        
        #expect(event.name == "apply_filter")
        #expect(event.parameters[AnalyticsParameterItemCategory] as? String == "Lamps")
        #expect(event.parameters["filter_price"] as? Double == 49.99)
        #expect(event.parameters["filter_rating"] as? Double == 4.5)
    }
    
    @Test("applySearch event maps fields correctly")
    func applySearch() {
        let event = FirebaseAnalyticsEvent.applySearch(searchTerm: "Sed", categoryName: "Lamps")
        
        #expect(event.name == AnalyticsEventSearch)
        #expect(event.parameters[AnalyticsParameterSearchTerm] as? String == "Sed")
        #expect(event.parameters[AnalyticsParameterItemCategory] as? String == "Lamps")
    }
    
    @Test("addToWishlist event maps fields correctly")
    func addToWishlist() {
        let event = FirebaseAnalyticsEvent.addToWishlist(id: "1", name: "Vindkast")
        
        #expect(event.name == AnalyticsEventAddToWishlist)
        #expect(event.parameters[AnalyticsParameterItemID] as? String == "1")
        #expect(event.parameters[AnalyticsParameterItemName] as? String == "Vindkast")
    }
    
    @Test("removeFromWishlist event maps fields correctly")
    func removeFromWishlist() {
        let event = FirebaseAnalyticsEvent.removeFromWishlist(id: "1", name: "Vindkast")
        
        #expect(event.name == "remove_from_wishlist")
        #expect(event.parameters[AnalyticsParameterItemID] as? String == "1")
        #expect(event.parameters[AnalyticsParameterItemName] as? String == "Vindkast")
    }
    
    @Test("addToCart event maps fields correctly")
    func addToCart() {
        let event = FirebaseAnalyticsEvent.addToCart(id: "1", name: "Vindkast")
        
        #expect(event.name == AnalyticsEventAddToCart)
        #expect(event.parameters[AnalyticsParameterItemID] as? String == "1")
        #expect(event.parameters[AnalyticsParameterItemName] as? String == "Vindkast")
    }
    
    @Test("removeFromCart event maps fields correctly")
    func removeFromCart() {
        let event = FirebaseAnalyticsEvent.removeFromCart(id: "1", name: "Vindkast")
        
        #expect(event.name == AnalyticsEventRemoveFromCart)
        #expect(event.parameters[AnalyticsParameterItemID] as? String == "1")
        #expect(event.parameters[AnalyticsParameterItemName] as? String == "Vindkast")
    }
    
    @Test("beginCheckout event maps fields correctly")
    func beginCheckout() {
        let event = FirebaseAnalyticsEvent.beginCheckout(items: [
            FirebaseAnalyticsEvent.AnalyticsItem(id: "1", name: "Vindkast", quantity: 1),
            FirebaseAnalyticsEvent.AnalyticsItem(id: "2", name: "Grinsbyn", quantity: 2)
        ])
        
        let items = event.parameters[AnalyticsParameterItems] as? [[String: Any]]
        let firstItem = items?.first
        let secondItem = items?.last
        
        #expect(event.name == AnalyticsEventBeginCheckout)
        #expect(firstItem?[AnalyticsParameterItemID] as? String == "1")
        #expect(firstItem?[AnalyticsParameterItemName] as? String == "Vindkast")
        #expect(firstItem?[AnalyticsParameterQuantity] as? Int == 1)
        #expect(secondItem?[AnalyticsParameterItemID] as? String == "2")
        #expect(secondItem?[AnalyticsParameterItemName] as? String == "Grinsbyn")
        #expect(secondItem?[AnalyticsParameterQuantity] as? Int == 2)
    }
}
