import SwiftUI
import Testing
@testable import Minimalist

struct FontTests {
    
    @Test
    func appName() async throws {
        #expect(Font.AppFont.appName == .system(size: 25, weight: .semibold))
    }
    
    @Test
    func headline() async throws {
        #expect(Font.AppFont.headline == .system(size: 17, weight: .semibold))
    }
    
    @Test
    func inputText() async throws {
        #expect(Font.AppFont.inputText == .system(size: 16, weight: .regular))
    }
    
    @Test
    func cardTitle() async throws {
        #expect(Font.AppFont.cardTitle == .system(size: 15, weight: .regular))
    }
    
    @Test
    func body() async throws {
        #expect(Font.AppFont.body == .system(size: 15, weight: .regular))
    }
    
    @Test
    func caption() async throws {
        #expect(Font.AppFont.caption == .system(size: 12, weight: .regular))
    }
}
