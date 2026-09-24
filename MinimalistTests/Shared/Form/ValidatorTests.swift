import Testing
@testable import Minimalist

@MainActor
struct ValidatorTests {

    // MARK: required
    
    @Test("Should return valid when the required value is not empty")
    func required_valid_whenNotEmpty() {
        #expect(Validator.required("Hannah", fieldName: "Name") == .valid)
        #expect(Validator.required("   Hannah   ", fieldName: "Name") == .valid)
    }
    
    @Test("Should return invalid when the required value is empty")
    func required_invalid_whenEmpty() {
        #expect(Validator.required("", fieldName: "Name") == .invalid("Name is required"))
        #expect(Validator.required("  ", fieldName: "Name") == .invalid("Name is required"))
    }
    
    @Test("Should use Field as the default required field name")
    func required_defaultFieldName() {
        #expect(Validator.required("") == .invalid("Field is required"))
    }
    
    // MARK: zipcode
    
    @Test(
        "Should accept a 6-digit ZIP code",
        arguments: ["90210", "K1A 0B1", "SW1A 1AA", "220030"]
    )
    func zipcode_valid(value: String) {
        #expect(Validator.zipcode(value) == .valid)
    }
    
    @Test(
        "Should reject an invalid ZIP code",
        arguments: ["", "1-2-3-4-5-6", "asdf", "   "]
    )
    func zipcode_invalid(value: String) {
        #expect(Validator.zipcode(value) == .invalid(ValidationError.zipcode.message))
    }
    
    // MARK: countryCity
    
    @Test(
        "Should accept a valid country and city",
        arguments: ["United States, New York", "Belarus, Minsk", "France, Clermont-Ferrand"]
    )
    func countryCity_valid(value: String) {
        #expect(Validator.countryCity(value) == .valid)
    }
    
    @Test(
        "Should reject an invalid country and city",
        arguments: ["", "Belarus", "Belarus, Minsk1", "123, Minsk"]
    )
    func countryCity_invalid(value: String) {
        #expect(Validator.countryCity(value) == .invalid(ValidationError.countryCity.message))
    }
    
    // MARK: name
    
    @Test(
        "Should accept a valid name",
        arguments: ["Hannah", "Mary-Kate", "Charlie Jo", "D'Angelo"]
    )
    func name_valid(value: String) {
        #expect(Validator.name(value) == .valid)
    }
    
    @Test(
        "Should reject an invalid name",
        arguments: ["", "   ", "A1", "123"]
    )
    func name_invalid(value: String) {
        #expect(Validator.name(value) == .invalid(ValidationError.name.message))
    }
    
    // MARK: address
    
    @Test(
        "Should accept a valid address",
        arguments: ["Gurskogo, 44", "Prospect Nezavisimosti 23-10", "123 Main St, Apt 4B"]
    )
    func address_valid(value: String) {
        #expect(Validator.address(value) == .valid)
    }
    
    @Test(
        "Should reject an invalid address",
        arguments: ["", "   ", "1234", "A"]
    )
    func address_invalid(value: String) {
        #expect(Validator.address(value) == .invalid(ValidationError.address.message))
    }
}
