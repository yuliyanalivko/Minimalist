import Testing
import SwiftUI
@testable import Minimalist

struct FavoritesRouterTests {

    @Test("path should be empty")
    func init_emptyPath() {
        let router = FavoritesRouter()
        
        #expect(router.path.count == 0)
    }
}
