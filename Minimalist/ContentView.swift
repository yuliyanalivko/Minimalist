import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var viewModel = AppViewModel()
    
    var body: some View {
        Group {
            switch viewModel.currentState {
            case .initializing:
                HomeView(viewModel: viewModel, showStartButton: false)
            case .readyToProceed:
                HomeView(viewModel: viewModel)
            case .started:
                MainTabView()
            }
        }
        .task {
            await viewModel.configureSDKs()
        }
    }
}

#Preview {
    ContentView()
}
