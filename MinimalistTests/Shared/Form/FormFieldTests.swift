import Testing
@testable import Minimalist

@MainActor
struct FormFieldTests {

    @Test("Should start with an empty value and no validation state")
    func init_defaultState() {
        let field = FormField(placeholder: "Name", validators: [])
        
        #expect(field.value == "")
        #expect(field.placeholder == "Name")
        #expect(field.state == nil)
        #expect(field.isValid == false)
    }
    
    @Test("Should be valid when the state is valid")
    func isValid_trueWhenStateValid() {
        var field = FormField(validators: [{ _ in .valid }])
        
        field.validate()
        
        #expect(field.isValid)
        #expect(field.state == .valid)
    }
    
    @Test("Should be invalid when the state is invalid")
    func isValid_falseWhenStateInvalid() {
        var field = FormField(validators: [{ _ in .invalid("Required") }])
        
        field.validate()
        
        #expect(!field.isValid)
        #expect(field.state == .invalid("Required"))
    }
    
    @Test("Should stop at the first failing validator")
    func validate_returnFirstInvalidState() {
        var field = FormField(
            value: "abc",
            validators: [
                { _ in .valid },
                { _ in .invalid("first") },
                { _ in .invalid("second") }
            ]
        )
        
        field.validate()
        
        #expect(field.state == .invalid("first"))
    }
    
    @Test("Should be valid when every validator passes")
    func validate_validWhenAllValidatorsPass() {
        var field = FormField(
            value: "Hannah",
            validators: [
                { value in Validator.required(value) },
                { value in value.count > 1 ? .valid : .invalid("Too short") }
            ]
        )
        
        field.validate()
        
        #expect(field.state == .valid)
    }
    
    @Test("Should be valid when there are no validators")
    func validate_validWhenNoValidators() {
        var field = FormField(value: "Hannah", validators: [])
        
        field.validate()
        
        #expect(field.state == .valid)
    }
    
    @Test("Should clear the value and validation state")
    func reset_clearValueAndState() {
        var field = FormField(value: "Hannah", placeholder: "Name", validators: [{ _ in .valid }])
        field.validate()
        
        field.reset()
        
        #expect(field.value == "")
        #expect(field.state == nil)
        #expect(field.placeholder == "Name")
        #expect(!field.isValid)
    }
}
