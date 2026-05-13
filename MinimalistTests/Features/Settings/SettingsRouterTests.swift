import Testing
import SwiftUI
@testable import Minimalist

struct SettingsRouterTests {

    @Test("path should be empty")
    func init_emptyPath() {
        let router = SettingsRouter()
        
        #expect(router.path.count == 0)
    }
}
