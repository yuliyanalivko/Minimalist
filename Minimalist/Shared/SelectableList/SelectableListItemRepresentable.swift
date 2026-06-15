import SwiftUI

protocol SelectableListItemRepresentable {
    var title: String? { get }
    var icon: String { get }
    var highlightedColor: Color { get }
    var inactiveColor: Color { get }
}
