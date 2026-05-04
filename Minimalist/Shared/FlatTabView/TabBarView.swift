import SwiftUI

struct TabBarView: View {
    let viewModel: FlatTabViewModel
    
    var body: some View {
        HStack {
            ForEach(Array(viewModel.tabs.enumerated()), id: \.offset) { index, tab in
                Spacer()
                
                VStack {
                    Image(systemName: tab.icon)
                        .font(.AppFont.icon)
                    
                    Text(tab.title)
                        .font(.AppFont.caption)
                        .padding(.top, 5)
                }
                .foregroundStyle(viewModel.isSelected(index) ? Color.AppColor.primary : Color.AppColor.textSecondary)
                .onTapGesture {
                    viewModel.selectedTabIndex = index
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
