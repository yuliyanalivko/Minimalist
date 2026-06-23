import SwiftUI

enum ImageState: Equatable {
    case loading
    case success(UIImage)
    case failed
}

protocol ImageCacheManaging {
    var cachedImages: [URL: ImageState] { get set }
    
    func load(url: URL)
    func load(urls: [URL?])
}

@Observable
class ImageLoader: ImageCacheManaging {
    var cachedImages: [URL: ImageState] = [:]
    
    private var task: Task<Void, Never>?
    private let cache = NSCache<NSURL, UIImage>()
    private let dataFetcher: any ImageDataFetching
    
    init(dataFetcher: any ImageDataFetching = URLSession.shared) {
        self.dataFetcher = dataFetcher
    }
    
    func load(url: URL) {
        guard cachedImages[url] == nil else { return }
        
        if let cachedImage = cache.object(forKey: url as NSURL) {
            self.cachedImages[url] = .success(cachedImage)
            
            return
        }
        
        task = Task {
            do {
                let data = try await dataFetcher.data(from: url)
                
                if let downloadedImage = UIImage(data: data) {
                    cache.setObject(downloadedImage, forKey: url as NSURL)
                    self.cachedImages[url] = .success(downloadedImage)
                }
            } catch {
                self.cachedImages[url] = .failed
            }
        }
    }
    
    func load(urls: [URL?]) {
        let validUrls = urls.compactMap { $0 }
        
        for url in validUrls {
            load(url: url)
        }
    }
}

protocol ImageDataFetching: Sendable {
    func data(from url: URL) async throws -> Data
}

extension URLSession: ImageDataFetching {
    func data(from url: URL) async throws -> Data {
        try await data(from: url).0
    }
}
