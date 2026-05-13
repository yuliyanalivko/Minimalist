import Testing
@testable import Minimalist

struct SettingsRouteTests {
    
    @Test("should return correct title for each route", arguments: [
        (SettingsRoute.settings, "Settings"),
    ])
    func title_returnCorrectValue(route: SettingsRoute, expectedTitle: String) {
        #expect(route.title == expectedTitle)
    }
}
