struct ViewItemList: FirebaseAnalyticsEvent {
    let name: String = FirebaseEventName.viewItemList
    var parameters: [String : Any]
    
    init(id: String, name: String) {
        parameters = [
            FirebaseParamName.listId: id,
            FirebaseParamName.listName: name,
        ]
    }
}

struct ViewItem: FirebaseAnalyticsEvent {
    let name: String = FirebaseEventName.viewItem
    var parameters: [String : Any]
    
    init(id: String, name: String, categoryName: String, subCategoryName: String? = nil) {
        parameters = [
            FirebaseParamName.itemId: id,
            FirebaseParamName.itemName: name,
            FirebaseParamName.categoryName: categoryName,
        ]
        
        if let subCategory = subCategoryName {
            parameters[FirebaseParamName.subCategoryName] = subCategory
        }
    }
}

struct ApplySearch: FirebaseAnalyticsEvent {
    let name: String = FirebaseEventName.applySearch
    var parameters: [String : Any]
    
    init(searchTerm: String, categoryName: String? = nil) {
        parameters = [
            FirebaseParamName.searchTerm: searchTerm
        ]
        
        if let categoryName {
            parameters[FirebaseParamName.categoryName] = categoryName
        }
    }
}

struct ApplyFilter: FirebaseAnalyticsEvent {
    let name: String = FirebaseEventName.applyFilter
    var parameters: [String : Any]
    
    enum Filter {
        case price(Double)
        case rating(Double)
        case category(String)
        
        var parameter: (key: String, value: Any) {
            switch self {
            case .price(let value):
                return (FirebaseParamName.filterPrice, value)
            case .rating(let value):
                return (FirebaseParamName.filterRating, value)
            case .category(let value):
                return (FirebaseParamName.filterCategory, value)
            }
        }
    }
    
    init(filters: [Filter], categoryName: String) {
        parameters = [
            FirebaseParamName.categoryName: categoryName
        ]
        
        for filter in filters {
            let (key, value) = filter.parameter
            parameters[key] = value
        }
    }
}
