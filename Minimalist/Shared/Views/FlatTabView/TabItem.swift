import Foundation
import SwiftUI

struct TabItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let icon: String
    let view: AnyView
    
    static func == (lhs: TabItem, rhs: TabItem) -> Bool {
        lhs.id == rhs.id
    }
}
