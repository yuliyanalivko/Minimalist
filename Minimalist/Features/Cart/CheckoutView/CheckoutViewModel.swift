import SwiftUI

@Observable
class CheckoutViewModel: RoutableViewModel<CartRouter> {
    let totalPrice: Double
    var showAlert: Bool = false
    
    var itemsLabel: String {
        "\(items.count) item\(items.count > 1 ? "s" : "")"
    }
    
    var nameField: FormField = FormField(
        placeholder: "Name",
        validators: [
            { value in
                Validator.required(value, fieldName: "Name")
            },
            Validator.name
        ]
    )
    
    var countryCityField: FormField = FormField(
        placeholder: "Country, city",
        validators: [
            { value in
                Validator.required(value, fieldName: "Country, city")
            },
            Validator.countryCity
        ]
    )
    
    var addressField: FormField = FormField(
        placeholder: "Address",
        validators: [
            { value in
                Validator.required(value, fieldName: "Address")
            },
            Validator.address
        ]
    )
    
    var zipcodeField: FormField = FormField(
        placeholder: "ZIP code",
        validators: [
            { value in
                Validator.required(value, fieldName: "ZIP code")
            },
            Validator.zipcode
        ]
    )
    
    private(set) var items: [Item]
    private var isFormValid: Bool = false
    private var orderDataCoordinator: OrderDataCoordinator
    
    init(
        router: CartRouter,
        items: [Item],
        orderDataCoordinator: OrderDataCoordinator = OrderDataCoordinator(),
        analyticsManager: AnalyticsManager? = nil
    ) {
        self.items = items
        self.totalPrice = items.reduce(0) { $0 + $1.price }
        self.orderDataCoordinator = orderDataCoordinator
 
        super.init(router: router, analyticsManager: analyticsManager)
    }
    
    func updateItems(items: [Item]) {
        self.items = items
    }
    
    func resetForm() {
        nameField.reset()
        countryCityField.reset()
        addressField.reset()
        zipcodeField.reset()
        
        isFormValid = true
    }
    
    func navigateBack() {
        router.navigateBack()
    }
    
    func onSubmit() async {
        validateForm()
                
        guard isFormValid else {
            return
        }
        
        guard let countryAndCity = parseCountryAndCity(value: countryCityField.value) else {
            return
        }
        
        let orderRequest = OrderRequest(
            username: nameField.value,
            city: countryAndCity.city,
            country: countryAndCity.country,
            address: addressField.value,
            zipcode: zipcodeField.value,
            items: items.map { $0.id }
        )
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            try await orderDataCoordinator.createOrder(order: orderRequest)
            showAlert = true
            logPurchaseEvent()
        } catch {
            setError(error)
        }
    }
    
    private func validateForm() {
        nameField.validate()
        countryCityField.validate()
        addressField.validate()
        zipcodeField.validate()
        
        isFormValid = !([nameField, countryCityField, addressField, zipcodeField]
            .contains { $0.state != .valid })
    }
    
    private func parseCountryAndCity(value: String) -> (country: String, city: String)? {
        guard let match = value.firstMatch(of: ValidationRegex.countryCity) else {
            return nil
        }
        
        return (
            country: String(match.country),
            city: String(match.city)
        )
    }
    
    private func logPurchaseEvent() {
        logEvent(AnalyticsEvent(
            name: AnalyticsEventName.purchase,
            parameters: [.quantity: items.count, .items: items.map { $0.id }]
        ))
    }
}
