import Testing
@testable import Minimalist

struct ItemListSheetTests {
    
    @Test("Should identify sheets by raw value", arguments: [
        (ItemListSheet.sort, "sort"),
        (ItemListSheet.filter, "filter")
    ])
    func id_matchesRawValue(sheet: ItemListSheet, expected: String) {
        #expect(sheet.id == expected)
        #expect(sheet.rawValue == expected)
    }
}
