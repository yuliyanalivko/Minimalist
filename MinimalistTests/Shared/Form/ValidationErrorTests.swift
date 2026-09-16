import Testing
@testable import Minimalist

@MainActor
struct ValidationErrorTests {

    @Test(
        "Should return the correct validation message",
        arguments: [
            (ValidationError.required(field: "Name"), "Name is required"),
            (.required(field: "ZIP code"), "ZIP code is required"),
            (.zipcode, "Please enter a valid ZIP code"),
            (.countryCity, "Please use the format 'Country, City' (e.g., Italy, Rome)"),
            (.name, "Please enter a valid name"),
            (.address, "Please enter a valid address")
        ]
    )
    func message_returnCorrectValue(error: ValidationError, expectedMessage: String) {
        #expect(error.message == expectedMessage)
    }
}
