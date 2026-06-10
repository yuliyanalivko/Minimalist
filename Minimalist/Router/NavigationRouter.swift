import SwiftUI

@Observable
final class NavigationRouter<T: Routable>: Router {
    typealias Route = T
    
    var path = NavigationPath()
}
