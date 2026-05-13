import SwiftUI

enum SettingsRoute: Hashable {
    case settings
    
    var title: String {
        switch self {
        case .settings:
            "Settings"
        }
    }
}
