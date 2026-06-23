import Foundation
import Testing
@testable import Minimalist

struct ImageLoaderTests {
    
    private let url = URL(string: "https://example.com/image.png")!
    
    private let pngData = Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==")!
    
    @Test("Should skip fetch when state already exists")
    func load_skipsWhenCached() async {
        let fetcher = MockImageDataFetcher(result: .success(pngData))
        let loader = ImageLoader(dataFetcher: fetcher)
        loader.cachedImages[url] = ImageState.loading
        
        loader.load(url: url)
        try? await Task.sleep(for: .milliseconds(50))
        
        #expect(fetcher.requestedURLs.isEmpty)
    }
    
    @Test("Should set success on valid image data")
    func load_success() async {
        let fetcher = MockImageDataFetcher(result: .success(pngData))
        let loader = ImageLoader(dataFetcher: fetcher)
        
        loader.load(url: url)
        try? await Task.sleep(for: .milliseconds(100))
        
        if case .success = loader.cachedImages[url] {
            #expect(fetcher.requestedURLs == [url])
        } else {
            Issue.record("Expected success")
        }
    }
    
    @Test("Should set failed on error")
    func load_failure() async {
        let fetcher = MockImageDataFetcher(result: .failure(URLError(.notConnectedToInternet)))
        let loader = ImageLoader(dataFetcher: fetcher)
        
        loader.load(url: url)
        try? await Task.sleep(for: .milliseconds(100))
        
        #expect(loader.cachedImages[url] == ImageState.failed)
    }
    
    @Test("Should load all valid URLs")
    func load_urls() async {
        let fetcher = MockImageDataFetcher(result: .success(pngData))
        let loader = ImageLoader(dataFetcher: fetcher)
        let url1 = URL(string: "https://example.com/1.png")!
        let url2 = URL(string: "https://example.com/2.png")!
        
        loader.load(urls: [url1, nil, url2])
        try? await Task.sleep(for: .milliseconds(100))
        
        #expect(fetcher.requestedURLs.count == 2)
    }
}
