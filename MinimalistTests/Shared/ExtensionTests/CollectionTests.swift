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
    
    struct MockProduct: Equatable {
        let name: String
    }
    
    private let collection = [
        MockProduct(name: "Garden Sofa"),
        MockProduct(name: "Table Lamp")
    ]
    
    @Test("returns allItems when search text is empty")
    func filtered_returnAllItems_emptySearch() {
        #expect(collection.filtered(by: "", key: \.name) == collection)
    }
    
    @Test("returns allItems when search text is not empty")
    func filtered_returnFilteredItems_nonemptySearch() {
        #expect(collection.filtered(by: "sofa", key: \.name) == [MockProduct(name: "Garden Sofa")])
    }
    
    @Test("returns allItems when search text contains only whitespaces")
    func filtered_returnFilteredItems_whitespacesSearch() {
        #expect(collection.filtered(by: "   ", key: \.name) == collection)
    }
    
    @Test("Should sort ascending by key path when order is forward")
    func sorted_returnAscending_forwardOrder() {
        let sorted = collection.sorted(by: \.name, order: .forward)
        
        #expect(sorted == [
            MockProduct(name: "Garden Sofa"),
            MockProduct(name: "Table Lamp")
        ])
    }
    
    @Test("Should sort descending by key path when order is reverse")
    func sorted_returnDescending_reverseOrder() {
        let sorted = collection.sorted(by: \.name, order: .reverse)
        
        #expect(sorted == [
            MockProduct(name: "Table Lamp"),
            MockProduct(name: "Garden Sofa")
        ])
    }
    
    @Test("Should default to forward order when order is omitted")
    func sorted_returnAscending_defaultOrder() {
        let sorted = collection.sorted(by: \.name)
        
        #expect(sorted.map(\.name) == ["Garden Sofa", "Table Lamp"])
    }
}
