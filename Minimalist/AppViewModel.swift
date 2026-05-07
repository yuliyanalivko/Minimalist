import SwiftUI

@Observable
class AppViewModel: BaseViewModel {
    var isStarted: Bool = false
    let showRoundedTabBar: Bool = true
}
