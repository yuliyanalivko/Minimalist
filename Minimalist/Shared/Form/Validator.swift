import Foundation

nonisolated enum Validator: Sendable {
    static func required(_ value: String, fieldName: String = "Field") -> ValidationState {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
        ? .invalid(ValidationError.required(field: fieldName).message)
        : .valid
    }
    
    static func name(_ value: String) -> ValidationState {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .wholeMatch(of: ValidationRegex.name) != nil
        ? .valid
        : .invalid(ValidationError.name.message)
    }
    
    static func zipcode(_ value: String) -> ValidationState {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .wholeMatch(of: ValidationRegex.zipcode) != nil
        ? .valid
        : .invalid(ValidationError.zipcode.message)
    }
    
    static func countryCity(_ value: String) -> ValidationState {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .wholeMatch(of: ValidationRegex.countryCity) != nil
        ? .valid
        : .invalid(ValidationError.countryCity.message)
    }
    
    static func address(_ value: String) -> ValidationState {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .wholeMatch(of: ValidationRegex.address) != nil
        ? .valid
        : .invalid(ValidationError.address.message)
    }
}
