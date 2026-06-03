struct AddToCart: FirebaseAnalyticsEvent {
    let name: String = FirebaseEventName.addToCart
    var parameters: [String : Any]
    
    init(id: String, name: String) {
        parameters = [
            FirebaseParamName.itemId: id,
            FirebaseParamName.itemName: name
        ]
    }
}

struct RemoveFromCart: FirebaseAnalyticsEvent {
    let name: String = FirebaseEventName.removeFromCart
    var parameters: [String : Any]
    
    init(id: String, name: String) {
        parameters = [
            FirebaseParamName.itemId: id,
            FirebaseParamName.itemName: name
        ]
    }
}

struct AddToWishlist: FirebaseAnalyticsEvent {
    let name: String = FirebaseEventName.addToWishlist
    var parameters: [String : Any]
    
    init(id: String, name: String) {
        parameters = [
            FirebaseParamName.itemId: id,
            FirebaseParamName.itemName: name
        ]
    }
}

struct RemoveFromWishlist: FirebaseAnalyticsEvent {
    let name: String = FirebaseEventName.removeFromWishlist
    var parameters: [String : Any]
    
    init(id: String, name: String) {
        parameters = [
            FirebaseParamName.itemId: id,
            FirebaseParamName.itemName: name
        ]
    }
}

struct BeginCheckout: FirebaseAnalyticsEvent {
    let name: String = FirebaseEventName.beginCheckout
    var parameters: [String : Any]
    
    init(items: [AnalyticsItem]) {
        parameters = [
            FirebaseParamName.items: items.map {[
                FirebaseParamName.itemId: $0.id,
                FirebaseParamName.itemName: $0.name,
                FirebaseParamName.quantity: $0.quantity
            ]}
        ]
    }
}

struct Purchase: FirebaseAnalyticsEvent {
    let name: String = FirebaseEventName.purchase
    var parameters: [String : Any]
    
    init(items: [AnalyticsItem]) {
        parameters = [
            FirebaseParamName.items: items.map {[
                FirebaseParamName.itemId: $0.id,
                FirebaseParamName.itemName: $0.name,
                FirebaseParamName.quantity: $0.quantity
            ]}
        ]
    }
}

struct AnalyticsItem: Equatable {
    let id: String
    let name: String
    let quantity: Int
}
