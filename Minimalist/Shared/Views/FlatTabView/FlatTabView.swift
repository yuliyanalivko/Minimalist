import SwiftUI

struct FlatTabView: View {
    let viewModel: FlatTabViewModel

    var body: some View {
        ZStack {
            viewModel.selectedTab.view
            
            VStack {
                Spacer()
                TabBarView(viewModel: viewModel)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}
