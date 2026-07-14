import SwiftUI

enum CatalogRoute: Routable {
    case category
    case itemList(title: String, id: String)
    case itemDetails(title: String, id: String)
    
    var title: String {
        switch self {
        case .category:
            "Catalog"
        case .itemList(let title, _):
            title
        case .itemDetails(let title, _):
            title
        }
        
    }
}
