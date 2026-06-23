import Foundation
@testable import Minimalist

final class MockImageLoader: ImageCacheManaging {
    var cachedImages: [URL: ImageState] = [:]
    
    private(set) var loadedURLs: [URL] = []
    
    func load(url: URL) {
        loadedURLs.append(url)
    }
    
    func load(urls: [URL?]) {
        urls.compactMap { $0 }.forEach { load(url: $0) }
    }
}
