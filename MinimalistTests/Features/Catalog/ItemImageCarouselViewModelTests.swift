import Testing
import SwiftUI
@testable import Minimalist

@Suite("ItemImageCarouselViewModel Tests")
struct ItemImageCarouselViewModelTests {
    
    func makeURLs(_ count: Int) -> [String] {
        (0..<count).map { "https://example.com/\($0).jpg" }
    }
    
    @Test("Should prefetch first three URLs")
    func preloadImages_prefetchesFirstThree() {
        let prefetcher = MockImagePrefetcher()
        let vm = ItemImageCarouselViewModel(
            imageUrls: makeURLs(5),
            imagePrefetcher: prefetcher
        )
        
        vm.preloadImages()
        
        #expect(prefetcher.calls.count == 1)
        #expect(prefetcher.lastPrefetchedURLs.count == 3)
        #expect(prefetcher.lastPrefetchedURLs.map(\.absoluteString) == [
            "https://example.com/0.jpg",
            "https://example.com/1.jpg",
            "https://example.com/2.jpg"
        ])
    }
}
