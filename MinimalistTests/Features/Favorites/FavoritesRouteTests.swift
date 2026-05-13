import Testing
@testable import Minimalist

struct FavoritesRouteTests {
    
    @Test("should return correct title for each route", arguments: [
        (FavoritesRoute.favorites, "Favorites"),
    ])
    func title_returnCorrectValue(route: FavoritesRoute, expectedTitle: String) {
        #expect(route.title == expectedTitle)
    }
}
