import SwiftUI
import Testing
@testable import Minimalist

@MainActor
struct CollectionTests {
    
    @Test("return nil when index is out of range")
    func subscript_returnNil_indexOutOfRange() async throws {
        let collection: [Int] = [1, 2, 3]
        
        #expect(collection[safe: 10] == nil)
    }
    
    @Test("return nil when index is negative")
    func subscript_returnNil_negativeIndex() async throws {
        let collection: [Int] = [1, 2, 3]
        
        #expect(collection[safe: -10] == nil)
    }
    
    @Test("return collection item when index is correct")
    func subscript_returnCollectionItem_correctIndex() async throws {
        let collection: [Int] = [1, 2, 3]
        
        #expect(collection[safe: 1] == 2)
    }
}
