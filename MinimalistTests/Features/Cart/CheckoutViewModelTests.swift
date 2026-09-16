import Foundation
import SwiftUI
import Testing
@testable import Minimalist

@MainActor
struct CheckoutViewModelTests {

    private func makeViewModel(
        items: [Item] = [item, item2],
        mockData: Data? = Data(),
        mockError: Error? = nil,
        router: CartRouter? = nil,
        analyticsManager: AnalyticsManager? = nil
    ) -> (CheckoutViewModel, MockNetworkClient) {
        let mockClient = MockNetworkClient(mockData: mockData, mockError: mockError)
        let vm = CheckoutViewModel(
            router: router ?? CartRouter(),
            items: items,
            orderDataCoordinator: OrderDataCoordinator(
                networkService: OrderNetworkService(networkClient: mockClient)
            ),
            analyticsManager: analyticsManager
        )
        
        return (vm, mockClient)
    }
    
    private func fillValidForm(_ vm: CheckoutViewModel) {
        vm.nameField.value = "Hannah"
        vm.countryCityField.value = "Belarus, Minsk"
        vm.addressField.value = "Gurskogo, 44"
        vm.zipcodeField.value = "220000"
    }

    @Test("Should store items and total price on init")
    func init_storeItemsAndTotalPrice() {
        let (vm, _) = makeViewModel(items: [item, item2])
        
        #expect(vm.items == [item, item2])
        #expect(vm.totalPrice == item.price + item2.price)
        #expect(vm.showAlert == false)
    }
    
    @Test("Should configure form field placeholders")
    func init_configureFormFieldPlaceholders() {
        let (vm, _) = makeViewModel()
        
        #expect(vm.nameField.placeholder == "Name")
        #expect(vm.countryCityField.placeholder == "Country, city")
        #expect(vm.addressField.placeholder == "Address")
        #expect(vm.zipcodeField.placeholder == "ZIP code")
    }
    
    @Test("Should use a singular item label for one item")
    func itemsLabel_singularForOneItem() {
        let (vm, _) = makeViewModel(items: [item])
        
        #expect(vm.itemsLabel == "1 item")
    }
    
    @Test("Should use a plural items label for multiple items")
    func itemsLabel_pluralForMultipleItems() {
        let (vm, _) = makeViewModel(items: [item, item2])
        
        #expect(vm.itemsLabel == "2 items")
    }
    
    @Test("Should replace items when updateItems is called")
    func updateItems_replaceItems() {
        let (vm, _) = makeViewModel(items: [item, item2])
        
        vm.updateItems(items: [item])
        
        #expect(vm.items == [item])
        #expect(vm.itemsLabel == "1 item")
    }
    
    @Test("Should clear form field values and validation state")
    func resetForm_clearFields() {
        let (vm, _) = makeViewModel()
        fillValidForm(vm)
        vm.nameField.validate()
        vm.countryCityField.validate()
        vm.addressField.validate()
        vm.zipcodeField.validate()
        
        vm.resetForm()
        
        #expect(vm.nameField.value == "")
        #expect(vm.countryCityField.value == "")
        #expect(vm.addressField.value == "")
        #expect(vm.zipcodeField.value == "")
        #expect(vm.nameField.state == nil)
        #expect(vm.countryCityField.state == nil)
        #expect(vm.addressField.state == nil)
        #expect(vm.zipcodeField.state == nil)
    }
    
    @Test("Should navigate back")
    func navigateBack_decrementsPath() {
        let router = CartRouter()
        router.navigate(to: CartRoute.checkout(items: [item, item2]))
        let (vm, _) = makeViewModel(router: router)
        
        vm.navigateBack()
        
        #expect(router.path.count == 0)
    }
    
    @Test("Should mark name as required when empty")
    func nameField_empty_requiredError() {
        let (vm, _) = makeViewModel()
        
        vm.nameField.validate()
        
        #expect(vm.nameField.state == .invalid("Name is required"))
    }
    
    @Test("Should accept a non-empty name")
    func nameField_filled_valid() {
        let (vm, _) = makeViewModel()
        vm.nameField.value = "Hannah"
        
        vm.nameField.validate()
        
        #expect(vm.nameField.state == .valid)
    }
    
    @Test("Should mark country and city as required when empty")
    func countryCityField_empty_requiredError() {
        let (vm, _) = makeViewModel()
        
        vm.countryCityField.validate()
        
        #expect(vm.countryCityField.state == .invalid("Country, city is required"))
    }
    
    @Test("Should reject country and city in the wrong format")
    func countryCityField_invalidFormat() {
        let (vm, _) = makeViewModel()
        vm.countryCityField.value = "Italy,Rome1"
        
        vm.countryCityField.validate()
        
        #expect(vm.countryCityField.state == .invalid(ValidationError.countryCity.message))
    }
    
    @Test("Should accept country and city in the expected format")
    func countryCityField_validFormat() {
        let (vm, _) = makeViewModel()
        vm.countryCityField.value = "Italy, Rome"
        
        vm.countryCityField.validate()
        
        #expect(vm.countryCityField.state == .valid)
    }
    
    @Test("Should mark address as required when empty")
    func addressField_empty_requiredError() {
        let (vm, _) = makeViewModel()
        
        vm.addressField.validate()
        
        #expect(vm.addressField.state == .invalid("Address is required"))
    }
    
    @Test("Should mark ZIP code as required when empty")
    func zipcodeField_empty_requiredError() {
        let (vm, _) = makeViewModel()
        
        vm.zipcodeField.validate()
        
        #expect(vm.zipcodeField.state == .invalid("ZIP code is required"))
    }
    
    @Test("Should reject an invalid ZIP code")
    func zipcodeField_invalidFormat() {
        let (vm, _) = makeViewModel()
        vm.zipcodeField.value = "asdf"
        
        vm.zipcodeField.validate()
        
        #expect(vm.zipcodeField.state == .invalid(ValidationError.zipcode.message))
    }
    
    @Test("Should accept a valid ZIP code")
    func zipcodeField_valid() {
        let (vm, _) = makeViewModel()
        vm.zipcodeField.value = "123456"
        
        vm.zipcodeField.validate()
        
        #expect(vm.zipcodeField.state == .valid)
    }
    
    @Test("Should not create an order when the form is invalid")
    func onSubmit_invalidForm_doesNotCreateOrder() async {
        let (vm, mockClient) = makeViewModel()
        
        await vm.onSubmit()
        
        #expect(mockClient.lastRequest == nil)
        #expect(vm.showAlert == false)
        #expect(vm.isLoading == false)
        #expect(vm.nameField.state == .invalid("Name is required"))
        #expect(vm.countryCityField.state == .invalid("Country, city is required"))
        #expect(vm.addressField.state == .invalid("Address is required"))
        #expect(vm.zipcodeField.state == .invalid("ZIP code is required"))
    }
    
    @Test("Should submit the order, show an alert, and log a purchase event")
    func onSubmit_success_showsAlertAndLogsPurchase() async throws {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let (vm, mockClient) = makeViewModel(analyticsManager: analyticsManager)
        fillValidForm(vm)
        
        await vm.onSubmit()
        
        guard let request = mockClient.lastRequest,
              let body = request.httpBody else {
            Issue.record("Expected order request to be sent")
            
            return
        }
        
        let order = try JSONDecoder().decode(OrderRequest.self, from: body)
        
        #expect(request.httpMethod == "POST")
        #expect(request.url?.path == "/api/v1/order")
        #expect(order.username == "Hannah")
        #expect(order.country == "Belarus")
        #expect(order.city == "Minsk")
        #expect(order.address == "Gurskogo, 44")
        #expect(order.zipcode == "220000")
        #expect(order.items == ["1", "2"])
        #expect(vm.showAlert == true)
        #expect(vm.isLoading == false)
        #expect(vm.error == nil)
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")
            
            return
        }
        
        #expect(name == AnalyticsEventName.purchase.rawValue)
        #expect(parameters[AnalyticsParamName.quantity.rawValue] as? Int == 2)
        #expect(parameters[AnalyticsParamName.items.rawValue] as? [String] == ["1", "2"])
    }
    
    @Test("Should set an error when creating the order fails")
    func onSubmit_networkFailure_setsError() async {
        let (vm, _) = makeViewModel(mockError: URLError(.badServerResponse))
        fillValidForm(vm)
        
        await vm.onSubmit()
        
        #expect(vm.showAlert == false)
        #expect(vm.isLoading == false)
        #expect(vm.error != nil)
    }
}
