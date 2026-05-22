import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    func trackScreen(_ screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName
        ])
    }
    
    func logEvent(_ event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}

enum AnalyticsEvent {
    case viewItemList(id: String, name: String)
    case viewItem(id: String, name: String, categoryName: String, subCategoryName: String?)
    case applyFilter(filters: [FilterType: Any], categoryName: String)
    case applySearch(searchTerm: String, categoryName: String?)
    case addToWishlist(id: String, name: String)
    case removeFromWishlist(id: String, name: String)
    case addToCart(id: String, name: String, price: Double)
    case removeFromCart(id: String, name: String, price: Double)
    case beginCheckout(totalPrice: Double, items: [AnalyticsItem])
    case purchase(totalPrice: Double, items: [AnalyticsItem])
    
    enum FilterType: String {
        case category = "category"
        case price = "price"
        case rating = "rating"
    }
    
    struct AnalyticsItem {
        let id: String
        let name: String
        let price: Double
        let quantity: Int
    }
    
    var name: String {
        switch self {
            
        case .viewItemList:
            return AnalyticsEventViewItemList
            
        case .viewItem:
            return AnalyticsEventViewItem
            
        case .applyFilter:
            return "apply_filter"
            
        case .applySearch:
            return AnalyticsEventSearch
            
        case .addToWishlist:
            return AnalyticsEventAddToWishlist
            
        case .removeFromWishlist:
            return "remove_from_wishlist"
            
        case .addToCart:
            return AnalyticsEventAddToCart
            
        case .removeFromCart:
            return AnalyticsEventRemoveFromCart
            
        case .beginCheckout:
            return AnalyticsEventBeginCheckout
            
        case .purchase:
            return AnalyticsEventPurchase
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .viewItemList(let id, let name):
            return [
                AnalyticsParameterItemListID: id,
                AnalyticsParameterItemListName: name,
            ]
            
        case .viewItem(let id, let name, let categoryName, let subCategoryName):
            var parameters = [
                AnalyticsParameterItemListID: id,
                AnalyticsParameterItemListName: name,
                AnalyticsParameterItemCategory: categoryName,
            ]
            
            if let subCategory = subCategoryName {
                parameters[AnalyticsParameterItemCategory2] = subCategory
            }
            
            return parameters
            
        case .applyFilter(let filters, let categoryName):
            var parameters: [String: Any] = [
                AnalyticsParameterItemCategory: categoryName,
            ]
            
            for (key, value) in filters {
                parameters["filter_\(key)"] = value
            }
            
            return parameters
            
        case .applySearch(let searchTerm, let categoryName):
            var parameters = [
                AnalyticsParameterSearchTerm: searchTerm,
            ]
            
            if let category = categoryName {
                parameters[AnalyticsParameterItemCategory] = category
            }
            
            return parameters
            
        case .addToWishlist(let id, let name):
            return [
                AnalyticsParameterItemID: id,
                AnalyticsParameterItemName: name
            ]
            
        case .removeFromWishlist(let id, let name):
            return [
                AnalyticsParameterItemID: id,
                AnalyticsParameterItemName: name
            ]
            
        case .addToCart(let id, let name, let price):
            return [
                AnalyticsParameterItemID: id,
                AnalyticsParameterItemName: name,
                AnalyticsParameterPrice: price
            ]
            
        case .removeFromCart(let id, let name, let price):
            return [
                AnalyticsParameterItemID: id,
                AnalyticsParameterItemName: name,
                AnalyticsParameterPrice: price
            ]
            
        case .beginCheckout(let totalPrice, let items):
            let items = items.map { item in
                [
                    AnalyticsParameterItemID: item.id,
                    AnalyticsParameterItemName: item.name,
                    AnalyticsParameterPrice: item.price,
                    AnalyticsParameterQuantity: item.quantity
                ]
            }
            
            var parameters: [String: Any] = [
                AnalyticsParameterValue: totalPrice,
                AnalyticsParameterItems: items
            ]
            
            return parameters
            
        case .purchase(let totalPrice, let items):
            let items = items.map { item in
                [
                    AnalyticsParameterItemID: item.id,
                    AnalyticsParameterItemName: item.name,
                    AnalyticsParameterPrice: item.price,
                    AnalyticsParameterQuantity: item.quantity
                ]
            }
            
            var parameters: [String: Any] = [
                AnalyticsParameterValue: totalPrice,
                AnalyticsParameterItems: items
            ]
            
            return parameters
        }
    }
}
