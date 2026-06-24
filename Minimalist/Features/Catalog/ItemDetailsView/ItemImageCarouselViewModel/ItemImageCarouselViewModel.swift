import SwiftUI

@Observable
class ItemImageCarouselViewModel {
    
    let imageUrls: [String]
    var selectedIndex: Int = 0
    let dotSize: CGFloat = 10
    
    var imageCount: Int {
        imageUrls.count
    }
    
    var slotCount: Int {
        min(maxVisibleDots, imageCount)
    }
    
    var imageHeight: CGFloat {
        UIScreen.main.bounds.width * 0.7
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
    
    private let maxVisibleDots = 10
    private let selectedPositionFromEnd = 3
    private let preloadedCount = 3
    private var imagePrefetcher: ImagePrefetching
    
    private var targetSelectedSlot: Int {
        maxVisibleDots - selectedPositionFromEnd
    }
    
    init(
        imageUrls: [String],
        imagePrefetcher: ImagePrefetching = Prefetcher(),
    ) {
        self.imageUrls = imageUrls
        self.imagePrefetcher = imagePrefetcher
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
    
    func preloadImages() {
        let urls = imageUrls
            .prefix(preloadedCount).compactMap { URL(string: $0) }
        
        imagePrefetcher.prefetch(urls: urls)
    }
}
