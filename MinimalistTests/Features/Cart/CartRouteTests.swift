import Testing
@testable import Minimalist

struct CartRouteTests {
    
    @Test("should return correct title for each route", arguments: [
        (CartRoute.cart, "Cart"),
    ])
    func title_returnCorrectValue(route: CartRoute, expectedTitle: String) {
        #expect(route.title == expectedTitle)
    }
}
