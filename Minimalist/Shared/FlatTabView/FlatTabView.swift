import SwiftUI

struct FlatTabView: View {
    let tabs: [TabItem]

    @State var selectedTabIndex: Int = 0
    
    var body: some View {
        ZStack {
            //TODO: tabs[selectedTabIndex].view
            Text(tabs[selectedTabIndex].title)
            
            VStack {
                Spacer()
                TabBarView(tabs: tabs, selectedTabIndex: $selectedTabIndex)
                    .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}
