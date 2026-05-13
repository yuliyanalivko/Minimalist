import SwiftUI

struct MainTabView: View {
    let vm = MainTabViewModel()
    
    var body: some View {
        ZStack {
            mainContent
            
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
        case 1:
            FavoritesView()
        case 2:
            CartView()
        case 3:
            SettingsView()
        default:
            Text(vm.selectedItem?.title ?? "")
        }
    }
}

#Preview {
    MainTabView()
}
