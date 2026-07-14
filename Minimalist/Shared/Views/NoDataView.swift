import SwiftUI

struct NoDataView: View {
    var body: some View {
        VStack {
            Image(systemName: "arrow.clockwise")
                .font(.AppFont.icon)
                .foregroundStyle(Color.AppColor.textSecondary)
                .padding(.bottom, 16)
            
            Text("Nothing was found")
                .font(.AppFont.headline)
                .padding(.bottom, 4)
            
            Text("Pull to refresh to try again")
                .font(.AppFont.body)
                .foregroundStyle(Color.AppColor.textSecondary)
        }
    }
}

#Preview {
    NoDataView()
}
