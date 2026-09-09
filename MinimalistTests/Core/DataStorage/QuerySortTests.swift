import Foundation
import SwiftData
import Testing
@testable import Minimalist

@MainActor
struct QuerySortTests {
    
    @Test("Should map name sort to the name key path")
    func keyPath_name() {
        #expect(QuerySort.name.keyPath == "name")
    }
    
    @Test("Should create a forward sort descriptor for name")
    func sortDescriptor_name_forwardOrder() {
        let descriptor: SortDescriptor<SwiftDataCategory> = QuerySort.name.sortDescriptor()
        
        #expect(descriptor.order == .forward)
    }
}
