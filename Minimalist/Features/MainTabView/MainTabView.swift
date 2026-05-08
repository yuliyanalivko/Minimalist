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
        
        @ViewBuilder
        var view: some View {
            switch self {
            case .catalog:
                CatalogView()
                
            case .favorites:
                Text(self.title)
                
            case .cart:
                Text(self.title)
                
            case .settings:
                Text(self.title)
            }
        }
    }
    
<<<<<<< HEAD:Minimalist/Features/MainTabView/MainTabView.swift
    private let viewModel = FlatTabViewModel(
        tabs: Tab.allCases.map { tab in
            TabItem(
                title: tab.title,
                icon: tab.icon,
                view: AnyView(tab.view)
            )
=======
    var mainContent: some View {
        // TODO: add cases for each tab
        switch vm.selectedItemIndex {
        default: Text(vm.items[vm.selectedItemIndex].title)
>>>>>>> main:Minimalist/MainTabView.swift
        }
    }
}

#Preview {
    MainTabView(showRoundedTabBar: true)
}
