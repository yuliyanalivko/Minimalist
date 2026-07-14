import SwiftUI

struct HomeView: View {
    let viewModel: AppViewModel
    var showStartButton: Bool = true
    
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
            
            Spacer()
                .frame(minHeight: 40, idealHeight: 130, maxHeight: 130)

            Button("Start shop") {
                viewModel.startTheApp()
            }
            .buttonStyle(PrimaryButtonStyle())
            .opacity(showStartButton ? 1 : 0)
            .disabled(!showStartButton)
                        
            Spacer()
                .frame(minHeight: 40, idealHeight: 130, maxHeight: 130)
            
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(16)
    }
}

#Preview {
    HomeView(viewModel: AppViewModel(), showStartButton: false)
}
