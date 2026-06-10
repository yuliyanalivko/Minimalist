import SwiftUI

enum SettingsRoute: Routable {
    case settings
    
    var title: String {
        switch self {
        case .settings:
            "Settings"
        }
    }
}
