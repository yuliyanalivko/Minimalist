import SwiftUI

struct RoundedTabBarView: View {
    let viewModel: TabBarDataModel
    
    var body: some View {
        HStack {
            ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, item in
                VStack {
                    Image(systemName: item.icon)
                        .font(.AppFont.icon)
                    
                    if viewModel.isSelected(index) {
                        Text(item.title ?? "")
                            .font(.AppFont.caption)
                            .padding(.top, 5)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding(8)
                .background(viewModel.isSelected(index) ? item.highlightedColor : Color.clear)
                .cornerRadius(40)
                .foregroundStyle(viewModel.isSelected(index) ? Color.AppColor.buttonTextPrimary : item.inactiveColor)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.select(index)
                    }
                }
            }
        }
        .padding(4)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 40))
        .padding(.horizontal, 16)
    }
}

#Preview {
    RoundedTabBarView(viewModel: MainTabViewModel())
}
