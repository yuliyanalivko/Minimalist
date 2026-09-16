import Testing
@testable import Minimalist

@MainActor
struct ValidationRegexTests {

    // MARK: countryCity
    
    @Test(
        "Should match a valid country and city",
        arguments: [
            ("Italy, Rome", "Italy", "Rome"),
            ("United Kingdom, London", "United Kingdom", "London"),
            ("Belarus, Minsk", "Belarus", "Minsk")
        ]
    )
    func countryCity_matchAndCaptureGroups(value: String, expectedCountry: String, expectedCity: String) {
        let match = value.wholeMatch(of: ValidationRegex.countryCity)
        
        #expect(match != nil)
        #expect(match.map { String($0.country) } == expectedCountry)
        #expect(match.map { String($0.city) } == expectedCity)
    }
    
    @Test(
        "Should not match an invalid country and city",
        arguments: [
            "Belarus",
            "Belarus, Minsk1",
            "Belarus; Minsk",
            ""
        ]
    )
    func countryCity_rejectInvalidValue(value: String) {
        #expect(value.wholeMatch(of: ValidationRegex.countryCity) == nil)
    }
    
    // MARK: name
    
    @Test(
        "Should match a valid name",
        arguments: ["Hannah", "Mary-Kate", "Charlie Jo", "D'Angelo"]
    )
    func name_matchValidValue(value: String) {
        #expect(value.wholeMatch(of: ValidationRegex.name) != nil)
    }
    
    @Test(
        "Should not match an invalid name",
        arguments: [" ", "123", "A1", ""]
    )
    func name_rejectInvalidValue(value: String) {
        #expect(value.wholeMatch(of: ValidationRegex.name) == nil)
    }
    
    // MARK: zipcode
    
    @Test(
        "Should match a valid zip code",
        arguments: ["90210", "K1A 0B1", "SW1A 1AA", "220030"]
    )
    func zipcode_matchValidValue(value: String) {
        #expect(value.wholeMatch(of: ValidationRegex.zipcode) != nil)
    }
    
    @Test(
        "Should not match an invalid zip code",
        arguments: [" ", "-123-", "A1", ""]
    )
    func zipcode_rejectInvalidValue(value: String) {
        #expect(value.wholeMatch(of: ValidationRegex.zipcode) == nil)
    }
    
    // MARK: address
    
    @Test(
        "Should match a valid address",
        arguments: [ "Gurskogo, 44", "Prospect Nezavisimosti 23-10", "123 Main St, Apt 4B"]
    )
    func address_matchValidValue(value: String) {
        #expect(value.wholeMatch(of: ValidationRegex.address) != nil)
    }
    
    @Test(
        "Should not match an invalid address",
        arguments: [" ", "123", "A1", ""]
    )
    func address_rejectInvalidValue(value: String) {
        #expect(value.wholeMatch(of: ValidationRegex.address) == nil)
    }
}
