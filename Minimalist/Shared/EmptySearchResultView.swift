import SwiftUI

struct EmptySearchResultView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "exclamationmark.magnifyingglass")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundStyle(Color.AppColor.backgroundSecondary)
                .padding(.bottom)
            
            Text("No result found")
                .font(.AppFont.appName)
            
            Spacer()
        }
        .verticalScreenSpacing()
    }
}

#Preview {
    EmptySearchResultView()
}
