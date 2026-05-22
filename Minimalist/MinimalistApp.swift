import SwiftUI
import SwiftData
import Firebase

@main
struct MinimalistApp: App {
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
