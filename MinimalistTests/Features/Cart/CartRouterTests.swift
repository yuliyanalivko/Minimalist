import Testing
import SwiftUI
@testable import Minimalist

struct CartRouterTests {

    @Test("path should be empty")
    func init_emptyPath() {
        let router = CartRouter()
        
        #expect(router.path.count == 0)
    }
}
