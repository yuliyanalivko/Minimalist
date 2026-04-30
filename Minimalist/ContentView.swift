import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var isStarted = false
    
    var body: some View {
        if isStarted {
            MainTabView()
        } else {
            HomeView(isStarted: $isStarted)
        }
    }
}

#Preview {
    ContentView()
}
