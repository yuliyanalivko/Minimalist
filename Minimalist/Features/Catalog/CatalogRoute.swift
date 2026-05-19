import SwiftUI

enum CatalogRoute: Hashable {
    case category
    case subcategory(title: String)
    case itemList(title: String)
    case itemDetails(title: String, id: String)
    
    var title: String {
        switch self {
        case .category:
            "Catalog"
        case .subcategory(let title):
            title
        case .itemList(let title):
            title
        case .itemDetails(let title, _):
            title
        }
        
    }
}
