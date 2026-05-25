import Testing
import UIKit
@testable import Minimalist

struct ImageTests {
    
    @Test("Icons should have correct names", arguments: [
        (AppIcon.heart, "heart.fill"),
        (AppIcon.sort, "arrow.up.arrow.down"),
        (AppIcon.filter, "line.3.horizontal.decrease"),
        (AppIcon.photo, "photo"),
        (AppIcon.star, "star.fill"),
        (AppIcon.magnifyingGlass, "exclamationmark.magnifyingglass")
    ])
    func appIcon_correctName(icon: AppIcon, expectedName: String) {
        #expect(icon.rawValue == expectedName)
    }
}
