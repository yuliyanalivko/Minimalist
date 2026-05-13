import SwiftUI

enum CatalogRoute: Hashable {
    case category
    case subcategory(title: String)
    
    var title: String {
        switch self {
        case .category:
            "Catalog"
        case .subcategory(let title):
            title
        }
    }
}
