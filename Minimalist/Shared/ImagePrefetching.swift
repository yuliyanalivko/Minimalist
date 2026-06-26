import Kingfisher
import Foundation

protocol ImagePrefetching {
    func prefetch(urls: [URL])
}

final class Prefetcher: ImagePrefetching {
    private var current: ImagePrefetcher?
    
    func prefetch(urls: [URL]) {
        guard !urls.isEmpty else { return }
        
        current = ImagePrefetcher(urls: urls)
        current?.start()
    }
}
