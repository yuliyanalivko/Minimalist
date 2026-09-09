import Foundation
import SwiftData

enum QuerySort {
    case name

    func sortDescriptor<T: Sortable>() -> SortDescriptor<T> {
        switch self {
        case .name:
            return SortDescriptor(\T.name, order: .forward)
        }
    }
        
    var keyPath: String {
        switch self {
        case .name:
            "name"
        }
    }
}
