import SwiftUI

struct FlatTabView: View {
    @State private var viewModel: FlatTabViewModel
    
    init(tabs: [TabItem], selectedTab: TabItem? = nil) {
        self.viewModel = FlatTabViewModel(tabs: tabs, selectedTab: selectedTab)
    }

    var body: some View {
        ZStack {
            //TODO: tabs[selectedTabIndex].view
            Text(viewModel.selectedTab.title)
            
            VStack {
                Spacer()
                TabBarView(viewModel: viewModel)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}
