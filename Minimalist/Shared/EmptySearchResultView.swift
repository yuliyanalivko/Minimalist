import SwiftUI

struct EmptySearchResultView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image.magnifyingGlass
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
