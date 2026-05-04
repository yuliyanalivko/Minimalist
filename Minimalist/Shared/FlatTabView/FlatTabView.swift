import SwiftUI

struct FlatTabView: View {
    let viewModel: FlatTabViewModel

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
