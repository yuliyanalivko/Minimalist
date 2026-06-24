import Testing
import SwiftUI
@testable import Minimalist

@Suite("ItemImageCarouselViewModel Tests")
struct ItemImageCarouselViewModelTests {
    
    func makeURLs(_ count: Int) -> [String] {
        (0..<count).map { "https://example.com/\($0).jpg" }
    }
    
    @Test("Should return imageCount when below max visible dots", arguments: [0, 1, 5, 10])
    func slotCount_matchesImageCountWhenSmall(imageCount: Int) {
        /* maxVisibleDots = 10 */
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(imageCount))
        
        #expect(vm.slotCount == imageCount)
    }
    
    @Test("Should return maxVisibleDots when imageCount exceeds max visible dots", arguments: [11, 14, 26])
    func slotCount_isCappedAtTen(imageCount: Int) {
        /* maxVisibleDots = 10 */
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(imageCount))
        
        #expect(vm.slotCount == 10)
    }
    
    @Test("Should stay at zero when all images fit in the dot bar")
    func startDotIndex_isZeroWhenImageCountFits() {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(8))
        vm.selectedIndex = 7
        
        #expect(vm.startDotIndex == 0)
    }
    
    @Test("Should stay at zero while selected index is in the first window", arguments: [0, 4, 7])
    func startDotIndex_isZeroAtBeginning(selectedIndex: Int) {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(14))
        vm.selectedIndex = selectedIndex
        
        #expect(vm.startDotIndex == 0)
    }
    
    @Test("Should slide when selected index passes the first window", arguments: [
        (selectedIndex: 8, expectedStart: 1),
        (selectedIndex: 9, expectedStart: 2),
        (selectedIndex: 10, expectedStart: 3),
        (selectedIndex: 13, expectedStart: 4)
    ])
    func startDotIndex_slidesInMiddle(selectedIndex: Int, expectedStart: Int) {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(14))
        vm.selectedIndex = selectedIndex
        
        #expect(vm.startDotIndex == expectedStart)
    }
    
    @Test("Should clamp to last window at the end")
    func startDotIndex_clampsAtEnd() {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(26))
        vm.selectedIndex = 25
        
        #expect(vm.startDotIndex == 16)
    }
    
    @Test("Should place selected index at third slot from the end in the middle of the list")
    func startDotIndex_placesSelectedThirdFromEnd() {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(14))
        vm.selectedIndex = 10
        let selectedSlot = vm.selectedIndex - vm.startDotIndex
        
        #expect(selectedSlot == vm.slotCount - 3)
    }
    
    @Test("Should map slots to image indices from startDotIndex")
    func indexForSlot_mapsFromWindowStart() {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(14))
        vm.selectedIndex = 10
        
        #expect(vm.startDotIndex == 3)
        #expect(vm.index(forSlot: 0) == 3)
        #expect(vm.index(forSlot: 5) == 8)
        #expect(vm.index(forSlot: 9) == 12)
    }
    
    @Test("Should update selectedIndex for valid index")
    func select_updatesSelectedIndex() {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(14))
        
        vm.select(5)
        
        #expect(vm.selectedIndex == 5)
    }
    
    @Test("Should ignore out-of-bounds indices", arguments: [-1, 14, 100] )
    func select_ignoresInvalidIndex(index: Int) {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(14))
        vm.selectedIndex = 3
        
        vm.select(index)
        
        #expect(vm.selectedIndex == 3)
    }
    
    @Test("Should return full size when all images fit")
    func dotSize_isFullWhenNoSlidingWindow() {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(6))
        vm.selectedIndex = 2
        
        #expect(vm.dotSize(forSlot: 0) == vm.dotSize)
        #expect(vm.dotSize(forSlot: 3) == vm.dotSize)
        #expect(vm.dotSize(forSlot: 5) == vm.dotSize)
    }
    
    @Test("Should return full size for selected index in sliding window")
    func dotSize_isFullForSelectedIndex() {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(14))
        vm.selectedIndex = 10
        
        let selectedSlot = 10 - vm.startDotIndex
        
        #expect(vm.dotSize(forSlot: selectedSlot) == vm.dotSize)
    }
    
    @Test("Should return half size at leading edge when window has scrolled")
    func dotSize_isHalfAtLeadingEdge() {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(14))
        vm.selectedIndex = 10
        
        #expect(vm.startDotIndex > 0)
        #expect(vm.dotSize(forSlot: 0) == vm.dotSize / 2)
    }
    
    @Test("Should return half size at trailing edge when more images remain")
    func dotSize_isHalfAtTrailingEdge() {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(14))
        vm.selectedIndex = 10
        
        #expect(vm.startDotIndex + vm.slotCount < vm.imageCount)
        #expect(vm.dotSize(forSlot: vm.slotCount - 1) == vm.dotSize / 2)
    }
    
    @Test("Should return reduced size at second slot from leading edge when window has scrolled")
    func dotSize_isReducedAtSecondLeadingEdge() {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(14))
        vm.selectedIndex = 10
        
        #expect(vm.dotSize(forSlot: 1) == vm.dotSize * 0.75)
    }
    
    @Test("Should return reduced size at second slot from trailing edge when more images remain")
    func dotSize_isReducedAtSecondTrailingEdge() {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(14))
        vm.selectedIndex = 10
        
        #expect(vm.dotSize(forSlot: vm.slotCount - 2) == vm.dotSize * 0.75)
    }
    
    @Test("Should return full size for middle slots in sliding window")
    func dotSize_isFullForMiddleSlots() {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(14))
        vm.selectedIndex = 10
        
        #expect(vm.dotSize(forSlot: 4) == vm.dotSize)
        #expect(vm.dotSize(forSlot: 5) == vm.dotSize)
    }
    
    @Test("Should not shrink trailing edge on last window")
    func dotSize_trailingEdgeFullOnLastWindow() {
        let vm = ItemImageCarouselViewModel(imageUrls: makeURLs(14))
        vm.selectedIndex = 13
        
        #expect(vm.startDotIndex == 4)
        #expect(vm.startDotIndex + vm.slotCount == vm.imageCount)
        #expect(vm.dotSize(forSlot: vm.slotCount - 1) == vm.dotSize)
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
