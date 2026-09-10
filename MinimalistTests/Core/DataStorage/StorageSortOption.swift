import Foundation
import SwiftData
import Testing
@testable import Minimalist

@MainActor
struct StorageSortOptionTests {
    
    @Test("Should map name sort to the name key path")
    func keyPath_name() {
        #expect(StorageSortOption.name.keyPath == "name")
    }
}
