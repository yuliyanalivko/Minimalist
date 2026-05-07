import SwiftUI

struct MainTabView: View {
    let showRoundedTabBar: Bool
    let vm = MainTabViewModel()
    
    var body: some View {
        ZStack {
            mainContent
            
            VStack {
                Spacer()
                
                if showRoundedTabBar {
                    RoundedTabBarView(viewModel: vm)
                        .ignoresSafeArea(edges: .bottom)
                } else {
                    FlatTabBarView(viewModel: vm)
                        .ignoresSafeArea(edges: .bottom)
                }
            }
        }
    }
    
    var mainContent: some View {
        // TODO: add cases for each tab
        switch vm.selectedItemIndex {
        default: Text(vm.items[vm.selectedItemIndex].title)
        }
    }
}

#Preview {
    MainTabView(showRoundedTabBar: true)
}
