import Testing
@testable import Minimalist

struct CatalogRouteTests {

    @Test("should return correct title for each route", arguments: [
        (CatalogRoute.category, "Catalog"),
        (CatalogRoute.itemList(title: "Kitchen Sofas"), "Kitchen Sofas"),
        (CatalogRoute.itemDetails(title: "Vindkast", id: "1"), "Vindkast"),
    ])
    func title_returnCorrectValue(route: CatalogRoute, expectedTitle: String) {
        #expect(route.title == expectedTitle)
    }
}
