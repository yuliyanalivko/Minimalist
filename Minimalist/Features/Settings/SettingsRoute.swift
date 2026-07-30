import SwiftUI

enum SettingsRoute: Routable {
    case settings
    case devTools
    case storage
    
    var title: String {
        switch self {
        case .settings:
            "Settings"
            
        case .devTools:
            "Developer tools"
            
        case .storage:
            "Data and Storage"
            
        }
    }
}
