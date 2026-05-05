import SwiftUI

struct HomeView: View {
    @Binding var isStarted: Bool

    var body: some View {
        VStack {
            Image("logo")
                .frame(width: 102, height: 104)
                .padding(.bottom, 28)
            
            Text("Minimalist")
                .font(.AppFont.appName)
                .textCase(.uppercase)
                .kerning(7)
                .padding(.bottom, 5)
            
            Text("furniture store")
                .font(.AppFont.body)
                .padding(.bottom, 130)
            
            Button("Start shop") {
                isStarted = true
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.bottom, 130)
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(16)
    }
}

#Preview {
    HomeView(isStarted: .constant(false))
}
