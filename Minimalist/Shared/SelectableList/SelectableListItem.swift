import SwiftUI

struct SelectableListItem: SelectableListItemRepresentable {
    let title: String?
    let icon: String
    let highlightedColor: Color
    let inactiveColor: Color
    
    init(
        title: String? = nil,
        icon: String,
        highlightedColor: Color,
        inactiveColor: Color
    ) {
        self.title = title
        self.icon = icon
        self.highlightedColor = highlightedColor
        self.inactiveColor = inactiveColor
    }
}
