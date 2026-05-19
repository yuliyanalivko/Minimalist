import SwiftUI

struct MainTabView: View {
    let viewModel = MainTabViewModel()
    
    var body: some View {
        ZStack {
            mainContent
            
            VStack {
                Spacer()
                
                if viewModel.showRoundedTabBar {
                    RoundedTabBarView(viewModel: viewModel)
                } else {
                    FlatTabBarView(viewModel: viewModel)
                        .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .tint(.AppColor.primary)
    }

    @ViewBuilder
    var mainContent: some View {
        // TODO: add cases for each tab
        switch viewModel.selectedItemIndex {
        case 0:
            CatalogView()
        case 1:
            FavoritesView()
        case 2:
            CartView()
        case 3:
            SettingsView()
        default:
            Text(viewModel.selectedItem?.title ?? "")
        }
    }
}

#Preview {
    MainTabView()
}
