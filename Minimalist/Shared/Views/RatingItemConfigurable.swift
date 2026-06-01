import SwiftUI

protocol TabBarItemConfigurable {
    var title: String { get }
    var icon: String { get }
    var selectedColor: Color { get }
    var unSelectedColor: Color { get }
}
