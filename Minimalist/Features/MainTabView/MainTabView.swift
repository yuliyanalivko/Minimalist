import SwiftUI

struct MainTabView: View {
    let vm = MainTabViewModel()
    
    var body: some View {
        ZStack {
            mainContent
                .safeAreaInset(edge: .bottom) {
                        Color.clear.frame(height: 80)
                    }
            
            VStack {
                Spacer()
                
                if vm.showRoundedTabBar {
                    RoundedTabBarView(viewModel: vm)
                } else {
                    FlatTabBarView(viewModel: vm)
                        .ignoresSafeArea(edges: .bottom)
                }
            }
        }
    }

    @ViewBuilder
    var mainContent: some View {
        // TODO: add cases for each tab
        switch vm.selectedItemIndex {
        case 0:
            CatalogView()
        default:
            Text(vm.selectedItem?.title ?? "")
        }
    }
}

#Preview {
    MainTabView()
}
