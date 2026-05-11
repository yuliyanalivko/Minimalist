import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var vm = AppViewModel()
    
    var body: some View {
        if vm.isStarted {
            MainTabView()
        } else {
            HomeView(vm: vm)
        }
    }
}

#Preview {
    ContentView()
}
