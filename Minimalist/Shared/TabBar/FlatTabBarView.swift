import SwiftUI

struct FlatTabBarView: View {
    let viewModel: TabBarDataModel
        
    var body: some View {
        HStack {
            ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, item in
                Spacer()
                
                VStack {
                    Image(systemName: item.icon)
                        .font(.AppFont.icon)
                    
                    Text(item.title ?? "")
                        .font(.AppFont.caption)
                        .padding(.top, 5)
                }
                .foregroundStyle(viewModel.isSelected(index) ? item.highlightedColor : item.inactiveColor)
                .onTapGesture {
                    viewModel.select(index)
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

#Preview {
    FlatTabBarView(viewModel: MainTabViewModel())
}
