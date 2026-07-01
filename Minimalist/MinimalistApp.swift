import SwiftUI
import SwiftData

@main
struct MinimalistApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    AppConfigurationManager.shared.initializeSDKs()
                }
        }
    }
}
