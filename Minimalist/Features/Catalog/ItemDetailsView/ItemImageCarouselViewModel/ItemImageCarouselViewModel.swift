import SwiftUI

@Observable
class ItemImageCarouselViewModel: BaseViewModel {
    
    var selectedIndex: Int = 0
    
    private(set) var imageUrls: [String] = []

    var imageCount: Int {
        imageUrls.count
    }
    
    var imageHeight: CGFloat {
        UIScreen.main.bounds.width * 0.7
    }
    
    private let preloadedCount = 3
    private var imagePrefetcher: ImagePrefetching
    
    init(
        imageUrls: [String] = [],
        imagePrefetcher: ImagePrefetching = Prefetcher(),
    ) {
        self.imageUrls = imageUrls
        self.imagePrefetcher = imagePrefetcher
    }
    
    func configure(imageUrls: [String]) {
        self.imageUrls = imageUrls
        selectedIndex = 0
        preloadImages()
    }
    
    func preloadImages() {
        let urls = imageUrls
            .prefix(preloadedCount).compactMap { URL(string: $0) }
        
        imagePrefetcher.prefetch(urls: urls)
    }
}
