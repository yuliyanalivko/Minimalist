import Testing
import SwiftUI
@testable import Minimalist

struct CatalogRouterTests {

    @Test("path should be empty")
    func init_emptyPath() {
        let router = CatalogRouter()
        
        #expect(router.path.count == 0)
    }
}
