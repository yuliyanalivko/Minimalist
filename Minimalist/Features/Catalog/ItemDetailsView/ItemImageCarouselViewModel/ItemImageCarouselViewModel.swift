import SwiftUI

@Observable
class ItemImageCarouselViewModel {
    
    let imageUrls: [String]
    var selectedIndex: Int = 0
    let dotSize: CGFloat = 10
    
    var urlsToPreload: [URL?] {
        Array(imageUrls.prefix(preloadedCount).map { URL(string: $0) })
    }
    
    var imageCount: Int {
        imageUrls.count
    }
    
    var slotCount: Int {
        min(maxVisibleDots, imageCount)
    }
    
    var imageHeight: CGFloat {
        UIScreen.main.bounds.width * 0.7
    }
    
    private let maxVisibleDots = 10
    private let selectedPositionFromEnd = 3
    private let preloadedCount: Int = 3
    private var imageLoader: ImageCacheManaging

    private var targetSelectedSlot: Int {
        maxVisibleDots - selectedPositionFromEnd
    }
    
    var startDotIndex: Int {
        if imageCount <= maxVisibleDots || selectedIndex <= targetSelectedSlot {
            return 0
        }
        
        return min(
            selectedIndex - targetSelectedSlot,
            imageCount - maxVisibleDots
        )
    }
    
    init(imageUrls: [String], imageLoader: ImageCacheManaging = ImageLoader()) {
        self.imageUrls = imageUrls
        self.imageLoader = imageLoader
    }
    
    func index(forSlot slot: Int) -> Int {
        startDotIndex + slot
    }
    
    func dotSize(forSlot slot: Int) -> CGFloat {
        let index = index(forSlot: slot)
        
        guard index < imageCount else { return dotSize }
        
        if index == selectedIndex || imageCount <= maxVisibleDots {
            return dotSize
        }
        
        let atLeadingEdge = slot == 0 && startDotIndex > 0
        let atTrailingEdge = slot == slotCount - 1 && startDotIndex + slotCount < imageCount
        
        let secondFromLeadingEdge = slot == 1 && startDotIndex > 0
        let secondFromTrailingEdge = slot == slotCount - 2 && startDotIndex + slotCount < imageCount
        
        return (atLeadingEdge || atTrailingEdge) ? dotSize * 0.5 : (secondFromLeadingEdge || secondFromTrailingEdge) ? dotSize * 0.75 : dotSize
    }
    
    func select(_ index: Int) {
        guard index >= 0, index < imageCount else { return }
        
        selectedIndex = index
    }
    
    func loadImage(url: URL) {        
        imageLoader.load(url: url)
    }
    
    func preloadImages() {
        imageLoader.load(urls: urlsToPreload)
    }
    
    func imageState(of url: URL) -> ImageState? {
        imageLoader.cachedImages[url]
    }
}
