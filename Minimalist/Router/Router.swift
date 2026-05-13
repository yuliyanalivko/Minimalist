import SwiftUI

protocol Router: Observable, AnyObject {
    var path: NavigationPath { get set }
    
    func navigate<T: Hashable>(to destination: T)}

extension Router {
    func navigate<T: Hashable>(to destination: T) {
        path.append(destination)
    }
}
