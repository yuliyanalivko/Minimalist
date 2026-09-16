struct FormField {
    var value = ""
    var placeholder: String = ""
    let validators: [(String) -> ValidationState]
    
    var isValid: Bool {
        state == .valid
    }
    
    private(set) var state: ValidationState? = nil
    
    /// Executes all verification rules on the current text,
    /// assigning either the first error found or a successful valid status to the field's state.
    mutating func validate() {
        state = validators
            .map { $0(value) }
            .first { $0 != .valid } ?? .valid
    }
    
    /// Clears out the user's input text and wipes the validation history,
    /// returning the field to its initial empty state
    mutating func reset() {
        state = nil
        value = ""
    }
}
