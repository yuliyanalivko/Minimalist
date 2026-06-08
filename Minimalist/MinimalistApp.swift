import SwiftUI
import SwiftData

@main
struct MinimalistApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await AppConfigurationManager.shared.initializeSDKs()
                }
        }
    }
}
