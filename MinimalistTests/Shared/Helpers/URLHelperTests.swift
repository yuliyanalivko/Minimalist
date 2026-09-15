import Foundation
import Testing
@testable import Minimalist

struct URLHelperTests {
    
    private struct ThumbnailItem: Equatable {
        var thumbnailUrl: String?
    }
    
    @Test("Should resize matching image URLs to 500")
    func mapUrls_resizesMatchingUrls() {
        let items = [ThumbnailItem(thumbnailUrl: "https://example.com/id/1041/200/200")]
        
        let result = URLHelper.mapUrls(of: items, keyPath: \.thumbnailUrl)
        
        #expect(result == [ThumbnailItem(thumbnailUrl: "https://example.com/id/1041/500/500")])
    }
    
    @Test("Should leave non-matching URLs unchanged")
    func mapUrls_leavesNonMatchingUrlsUnchanged() {
        let items = [ThumbnailItem(thumbnailUrl: "https://example.com/photo.jpg")]
        
        let result = URLHelper.mapUrls(of: items, keyPath: \.thumbnailUrl)
        
        #expect(result == items)
    }
    
    @Test("Should leave nil URLs unchanged")
    func mapUrls_leavesNilUrlsUnchanged() {
        let items = [ThumbnailItem(thumbnailUrl: nil)]
        
        let result = URLHelper.mapUrls(of: items, keyPath: \.thumbnailUrl)
        
        #expect(result == items)
    }
    
    @Test("Should leave empty URL strings unchanged")
    func mapUrls_leavesEmptyUrlsUnchanged() {
        let items = [ThumbnailItem(thumbnailUrl: "")]
        
        let result = URLHelper.mapUrls(of: items, keyPath: \.thumbnailUrl)
        
        #expect(result == items)
    }
}
