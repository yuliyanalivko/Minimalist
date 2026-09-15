nonisolated enum ValidationError {
    case required(field: String)
    case zipcode
    case countryCity
    
    var message: String {
        switch self {
        case .required(let field):
            "\(field) is required"
            
        case .zipcode:
            "Please enter a valid ZIP code"
            
        case .countryCity:
            "Please use the format 'Country, City' (e.g., Italy, Rome) "
        }
    }
}
