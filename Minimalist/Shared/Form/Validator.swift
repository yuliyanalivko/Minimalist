nonisolated enum Validator: Sendable {
    static func required(_ value: String, fieldName: String = "Field") -> ValidationState {
        value.isEmpty ? .invalid(ValidationError.required(field: fieldName).message) : .valid
    }
    
    static func zipcode(_ value: String) -> ValidationState {
        value.allSatisfy { $0.isWholeNumber } && value.count == 6
        ? .valid
        : .invalid(ValidationError.zipcode.message)
    }
    
    static func countryCity(_ value: String) -> ValidationState {
        value.wholeMatch(of: ValidationRegex.countryCity) != nil ? .valid : .invalid(ValidationError.countryCity.message)
    }
}
