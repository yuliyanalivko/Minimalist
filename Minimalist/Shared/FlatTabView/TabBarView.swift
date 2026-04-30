import SwiftUI

struct TabBarView: View {
    let tabs: [TabItem]
    
    @Binding var selectedTabIndex: Int
    
    var body: some View {
        HStack {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Spacer()
                
                VStack {
                    Image(systemName: tab.icon)
                        .font(.system(size: 28))
                    
                    ZStack {
                        Text(tab.title)
                            .fontWeight(.bold)
                            .opacity(selectedTabIndex == index ? 1 : 0)
                        
                        Text(tab.title)
                            .fontWeight(.medium)
                            .opacity(selectedTabIndex == index ? 0 : 1)
                    }
                    .font(.AppFont.caption)
                    .padding(.top, 5)
                }
                .foregroundStyle(selectedTabIndex == index ? Color.AppColor.primary : Color.AppColor.textSecondary)
                .onTapGesture {
                    selectedTabIndex = index
                }
                
                Spacer()
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color.AppColor.backgroundSecondary)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.AppColor.textSecondary)
                .opacity(0.3),
            alignment: .top
        )
        
    }
}
