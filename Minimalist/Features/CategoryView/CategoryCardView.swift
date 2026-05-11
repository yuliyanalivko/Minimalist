import SwiftUI

struct CategoryCardView: View {
    let title: String
    var icon: String?
    
    var body: some View {
        VStack {
            if let iconName = icon {
                Image(iconName)
                    .foregroundStyle(Color.AppColor.primary)
            }
            
            Text(title)
                .font(Font.AppFont.cardTitle)
                .foregroundStyle(Color.AppColor.textPrimary)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .modifier(CardBorder())
    }
}

#Preview {
    CategoryCardView(title: "Title")
}
