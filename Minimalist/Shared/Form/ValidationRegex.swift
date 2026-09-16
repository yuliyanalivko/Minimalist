nonisolated enum ValidationRegex {
    
    /// Matches strings like "Hannah", "Mary-Kate", "Charlie Jo", "D'Angelo".
    static let name = /^\p{L}+[\p{L}'\-\s]*\p{L}+$/
    
    /// Matches strings like "Belarus, Minsk", "United States, New York", "France, Clermont-Ferrand".
    static let countryCity = /^(?<country>[a-zA-Z](?:[a-zA-Z\s\-]*[a-zA-Z])?)\s*,\s*(?<city>[a-zA-Z](?:[a-zA-Z\s\-]*[a-zA-Z])?)$/
    
    /// Matches strings like "90210", "K1A 0B1", "SW1A 1AA", "220030"
    static let zipcode = /^[A-Z0-9][A-Z0-9\s\-]{1,8}[A-Z0-9]$/
    
    /// Matches strings like "Gurskogo, 44", "Prospect Nezavisimosti 23-10", "123 Main St, Apt 4B"
    static let address = /^[\p{L}\p{N}\s.,\-\/№#]{5,150}$/
}
