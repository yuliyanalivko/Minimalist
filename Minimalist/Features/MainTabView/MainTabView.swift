import SwiftUI

struct MainTabView: View {
    let viewModel = MainTabViewModel()

    var body: some View {
        ZStack {
            mainContent
                .contentMargins(.bottom, viewModel.isKeyboardVisible ? 0 : 100, for: .scrollContent)
            
            VStack {
                Spacer()
                if viewModel.showRoundedTabBar {
                    RoundedTabBarView(viewModel: viewModel)
                } else {
                    FlatTabBarView(viewModel: viewModel)
                }
            }
            .ignoresSafeArea(.keyboard)
            
        }
        .toast()
        .tint(.AppColor.primary)
        .onReceive(viewModel.keyboardPublisher) {
            viewModel.isKeyboardVisible = $0
        }
    }
    
    @ViewBuilder
    var mainContent: some View {
        switch viewModel.selectedItemIndex {
        case 0:
            CatalogView(viewModel: viewModel.catalogViewModel)
        case 1:
            FavoritesView(viewModel: viewModel.favoritesViewModel)
        case 2:
            CartView(viewModel: viewModel.cartViewModel)
        case 3:
            SettingsView(viewModel: viewModel.settingsViewModel)
        default:
            Text(viewModel.selectedItem?.title ?? "")
        }
    }
}

#Preview {
    MainTabView()
}
