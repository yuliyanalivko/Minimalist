struct FormField {
    var value = ""
    var placeholder: String = ""
    let validators: [(String) -> ValidationState]
    
    var isValid: Bool {
        state == .valid
    }
    
    private(set) var state: ValidationState? = nil

    mutating func validate() {
        state = validators
            .map { $0(value) }
            .first { $0 != .valid } ?? .valid
    }
    
    mutating func reset() {
        state = nil
        value = ""
    }
}
