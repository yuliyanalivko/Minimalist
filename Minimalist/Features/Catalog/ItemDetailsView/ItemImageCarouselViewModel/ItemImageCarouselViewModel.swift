import SwiftUI

@Observable
class ItemImageCarouselViewModel: BaseViewModel {
    
    let imageUrls: [String]
    var selectedIndex: Int = 0
    
    var imageCount: Int {
        imageUrls.count
    }
    
    var imageHeight: CGFloat {
        UIScreen.main.bounds.width * 0.7
    }
    
    private let preloadedCount = 3
    private var imagePrefetcher: ImagePrefetching
    
    init(
        imageUrls: [String],
        imagePrefetcher: ImagePrefetching = Prefetcher(),
    ) {
        self.imageUrls = imageUrls
        self.imagePrefetcher = imagePrefetcher
    }
    
    func preloadImages() {
        let urls = imageUrls
            .prefix(preloadedCount).compactMap { URL(string: $0) }
        
        imagePrefetcher.prefetch(urls: urls)
    }
}
