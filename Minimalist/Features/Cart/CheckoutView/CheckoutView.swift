import SwiftUI

struct CheckoutView: View {
    @State var viewModel: CheckoutViewModel
    
    var body: some View {
        ScrollView {
            HStack {
                Text("Items")
                    .textCase(.uppercase)
                    .foregroundStyle(Color.AppColor.textPrimary)
                
                Spacer()
                
                Text(viewModel.itemsLabel)
                    .foregroundStyle(Color.AppColor.primary)
            }
            .font(.AppFont.headline)
            .padding(.bottom, 20)
            
            HStack {
                Text("Price")
                    .textCase(.uppercase)
                    .foregroundStyle(Color.AppColor.textPrimary)
                
                Spacer()
                
                Text("\(viewModel.totalPrice, specifier: "%.2f") $")
                    .foregroundStyle(Color.AppColor.primary)
            }
            .font(.AppFont.headline)
            
            Form {
                VStack(spacing: 28) {
                    TextFieldControl(
                        value: $viewModel.nameField.value,
                        placeholder: viewModel.nameField.placeholder,
                        validationState: viewModel.nameField.state,
                        onLostFocus: { viewModel.nameField.validate() }
                    )
                    
                    TextFieldControl(
                        value: $viewModel.countryCityField.value,
                        placeholder: viewModel.countryCityField.placeholder,
                        validationState: viewModel.countryCityField.state,
                        onLostFocus: { viewModel.countryCityField.validate() }
                    )
                    
                    TextFieldControl(
                        value: $viewModel.addressField.value,
                        placeholder: viewModel.addressField.placeholder,
                        validationState: viewModel.addressField.state,
                        onLostFocus: { viewModel.addressField.validate() }
                    )
                    
                    TextFieldControl(
                        value: $viewModel.zipcodeField.value,
                        placeholder: viewModel.zipcodeField.placeholder,
                        validationState: viewModel.zipcodeField.state,
                        onLostFocus: { viewModel.zipcodeField.validate() }
                    )
                }
            }
            .onSubmit {
                Task {
                    await viewModel.onSubmit()
                }
            }
            .formStyle(.columns)
            .padding(.top, 58)
        }
        .alert("Your order has been submitted", isPresented: $viewModel.showAlert) {
            Button("Ok") {
                viewModel.navigateBack()
            }
        } message: {
            Text("Thank you for ordering! We will begin processing it soon.")
        }
        .overlay(alignment: .bottom) {
            Button {
                Task {
                    await viewModel.onSubmit()
                }
            } label: {
                Text("Pay")
                    .frame(maxWidth: .infinity)
                    .textCase(.uppercase)
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.bottom, 10)
            .tabBarAwareCentering()
            .keyboardShortcut(.defaultAction)
        }
        .defaultHorizontalScreenPadding()
        .verticalScreenSpacing()
        .onAppear {
            viewModel.resetForm()
        }
    }
}

#Preview {
    CheckoutView(viewModel: CheckoutViewModel(
        router: .init(),
        items: [
            Item(
                id: "1",
                name: "Sofa",
                category: nil,
                subcategory: nil,
                rating: 3.5,
                isFavorited: false,
                isAddedToCart: true,
                price: 30.99,
            ),
            Item(
                id: "2",
                name: "Table",
                category: nil,
                subcategory: nil,
                rating: 3.5,
                isFavorited: false,
                isAddedToCart: true,
                price: 030.99,
            ),
        ])
    )
}
