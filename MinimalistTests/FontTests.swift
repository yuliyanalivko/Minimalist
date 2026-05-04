import SwiftUI
import Testing
@testable import Minimalist

struct FontTests {
    
    @Test
    func appName_hasExpectedSizeAndWeight() async throws {
        #expect(Font.AppFont.appName == .system(size: 25, weight: .semibold))
    }
    
    @Test
    func headline_hasExpectedSizeAndWeight() async throws {
        #expect(Font.AppFont.headline == .system(size: 17, weight: .semibold))
    }
    
    @Test
    func inputText_hasExpectedSizeAndWeight() async throws {
        #expect(Font.AppFont.inputText == .system(size: 16, weight: .regular))
    }
    
    @Test
    func cardTitle_hasExpectedSizeAndWeight() async throws {
        #expect(Font.AppFont.cardTitle == .system(size: 15, weight: .regular))
    }
    
    @Test
    func body_hasExpectedSizeAndWeight() async throws {
        #expect(Font.AppFont.body == .system(size: 15, weight: .regular))
    }
    
    @Test
    func caption_hasExpectedSizeAndWeight() async throws {
        #expect(Font.AppFont.caption == .system(size: 12, weight: .regular))
    }
    
    @Test
    func icon_hasExpectedSizeAndWeight() async throws {
        #expect(Font.AppFont.icon == .system(size: 24, weight: .regular))
    }
}
