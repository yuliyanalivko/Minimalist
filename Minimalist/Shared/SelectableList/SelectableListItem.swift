import SwiftUI

struct SelectableListItem: SelectableListItemRepresentable {
    let title: String?
    let icon: String
    let highlightedColor: Color
    let inactiveColor: Color
    var badgeText: String?
    
    init(
        title: String? = nil,
        icon: String,
        highlightedColor: Color,
        inactiveColor: Color,
        badgeText: String? = nil
    ) {
        self.title = title
        self.icon = icon
        self.highlightedColor = highlightedColor
        self.inactiveColor = inactiveColor
        self.badgeText = badgeText
    }
}
