import SwiftUI

struct CatalogCardView: View {
    let title: String
    var icon: String?
    
    var body: some View {
        VStack {
            if icon != nil {
                Image(icon!)
                    .foregroundStyle(Color.AppColor.primary)
            }
            
            Text(title)
                .font(Font.AppFont.cardTitle)
                .foregroundStyle(Color.AppColor.textPrimary)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.AppColor.backgroundSecondary, lineWidth: 2.5)
        )
    }
}

#Preview {
    CatalogCardView(title: "Title")
}
