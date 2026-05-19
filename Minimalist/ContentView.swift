import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var viewModel = AppViewModel()
    
    var body: some View {
        if viewModel.isStarted {
            MainTabView()
        } else {
            HomeView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}
