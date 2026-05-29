import Foundation
import FirebaseAnalytics

final class FirebaseAnalyticsManager: ScreenTracking, EventTracking {
    static let shared = FirebaseAnalyticsManager()
    
    private init() {}
    
    func trackScreen(_ screenName: String) {
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: screenName
        ])
    }
    
    func logEvent(_ event: FirebaseAnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}

enum FirebaseAnalyticsEvent: AnalyticsEvent, Equatable {
    case viewItemList(id: String, name: String)
    case viewItem(id: String, name: String, categoryName: String, subCategoryName: String?)
    case applyFilter(filters: [FilterType: FilterValue], categoryName: String)
    case applySearch(searchTerm: String, categoryName: String?)
    case addToWishlist(id: String, name: String)
    case removeFromWishlist(id: String, name: String)
    case addToCart(id: String, name: String)
    case removeFromCart(id: String, name: String)
    case beginCheckout(items: [AnalyticsItem])
    case purchase(items: [AnalyticsItem])
    case remoteConfigFetchFailed(description: String)
    
    enum FilterType: String {
        case category = "category"
        case price = "price"
        case rating = "rating"
    }
    
    enum FilterValue: Equatable {
        case string(String)
        case double(Double)
        
        var value: Any {
            switch self {
            case .string(let text): return text
            case .double(let number): return number
            }
        }
    }
    
    struct AnalyticsItem: Equatable {
        let id: String
        let name: String
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
            
        case .remoteConfigFetchFailed:
            return "remote_config_fetch_fail"
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
                parameters["filter_\(key)"] = value.value
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
            
        case .addToCart(let id, let name):
            return [
                AnalyticsParameterItemID: id,
                AnalyticsParameterItemName: name,
            ]
            
        case .removeFromCart(let id, let name):
            return [
                AnalyticsParameterItemID: id,
                AnalyticsParameterItemName: name,
            ]
            
        case .beginCheckout(let items):
            let items = items.map { item in
                [
                    AnalyticsParameterItemID: item.id,
                    AnalyticsParameterItemName: item.name,
                    AnalyticsParameterQuantity: item.quantity
                ]
            }
            
            let parameters: [String: Any] = [
                AnalyticsParameterItems: items
            ]
            
            return parameters
            
        case .purchase(let items):
            let items = items.map { item in
                [
                    AnalyticsParameterItemID: item.id,
                    AnalyticsParameterItemName: item.name,
                    AnalyticsParameterQuantity: item.quantity
                ]
            }
            
            let parameters: [String: Any] = [
                AnalyticsParameterItems: items
            ]
            
            return parameters
            
        case .remoteConfigFetchFailed(let description):
            return [
                "error_message": String(description.prefix(100))
            ]
        }
    }
}

extension FirebaseAnalyticsEvent.FilterValue: ExpressibleByFloatLiteral, ExpressibleByStringLiteral {
    
    init(floatLiteral value: Double) {
        self = .double(value)
    }
    
    init(stringLiteral value: String) {
        self = .string(value)
    }
}
