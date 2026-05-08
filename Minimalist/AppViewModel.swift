import SwiftUI

@Observable
class AppViewModel: BaseViewModel {
    var isStarted: Bool = false
    var showRoundedTabBar: Bool = true
}
