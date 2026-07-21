import SwiftUI

enum SettingsRoute: Routable {
    case settings
    case devTools
    
    var title: String {
        switch self {
        case .settings:
            "Settings"
            
        case .devTools:
            "Developer tools"
        }
    }
}
