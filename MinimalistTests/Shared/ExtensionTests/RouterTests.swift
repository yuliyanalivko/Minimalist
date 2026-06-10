import SwiftUI
import Testing
@testable import Minimalist

struct RouterTests {

    enum RouteMock: Hashable {
        case screenA
    }

    @Observable
    class TestRouter: Router {
        var path = NavigationPath()
    }
    
    @Test("should add route to path")
    func navigate_addRoute() {
        let router = TestRouter()
        
        router.navigate(to: RouteMock.screenA)
        
        #expect(router.path.count == 1)
    }
}
