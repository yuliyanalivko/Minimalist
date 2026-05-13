import Testing
@testable import Minimalist

struct CatalogRouteTests {

    @Test("should return correct title for each route", arguments: [
        (CatalogRoute.category, "Catalog"),
        (CatalogRoute.subcategory(title: "Sofas"), "Sofas"),
    ])
    func title_returnCorrectValue(route: CatalogRoute, expectedTitle: String) {
        #expect(route.title == expectedTitle)
    }
}
