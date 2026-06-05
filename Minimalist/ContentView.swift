import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var viewModel = AppViewModel()
    
    @ObservedObject private var configurationManager: AppConfigurationManager = AppConfigurationManager.shared
    
    var body: some View {
        if configurationManager.isInitialized && viewModel.isStarted {
            MainTabView()
        } else {
            HomeView(viewModel: viewModel, showStartButton: configurationManager.isInitialized)
        }
    }
}

#Preview {
    ContentView()
}
