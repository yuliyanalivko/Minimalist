struct OrderRequest: Codable {
    var username: String
    var city: String
    var country: String
    var address: String
    var zipcode: String
    let items: [String]
}
