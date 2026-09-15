import Foundation
import SwiftData

enum StorageSortOption: String {
    case name = "name"
    
    var keyPath: String {
        self.rawValue
    }
}
