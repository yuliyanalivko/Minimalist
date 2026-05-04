import SwiftUI

struct TabBarView: View {
    let viewModel: FlatTabViewModel
    
    var body: some View {
        HStack {
            ForEach(viewModel.tabs) { tab in
                Spacer()
                
                VStack {
                    Image(systemName: tab.icon)
                        .font(.AppFont.icon)
                    
                    ZStack {
                        Text(tab.title)
                            .fontWeight(.bold)
                            .opacity(viewModel.isSelected(tab) ? 1 : 0)
                        
                        Text(tab.title)
                            .fontWeight(.medium)
                            .opacity(viewModel.isSelected(tab) ? 0 : 1)
                    }
                    .font(.AppFont.caption)
                    .padding(.top, 5)
                }
                .foregroundStyle(viewModel.isSelected(tab) ? Color.AppColor.primary : Color.AppColor.textSecondary)
                .onTapGesture {
                    viewModel.select(tab)
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
