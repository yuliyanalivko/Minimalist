import SwiftUI

@Observable
class ItemDetailsViewModel: BaseViewModel {
    var itemDetails: ItemDetails?
    
    var itemImageCarouselViewModel: ItemImageCarouselViewModel
    var itemReviewsViewModel: ItemReviewsViewModel
    
    var state: ContentState<ItemDetails> {
        if isLoading { return .loading }
        
        guard let itemDetails else {
            return .empty
        }
        
        return .content(itemDetails)
    }
    
    var overlayAligment: Alignment {
        guard let itemDetails else {
            return .center
        }
        
        return state == .content(itemDetails) ? .bottom : .center
    }
    
    private let id: String
    private let dataCoordinator: CatalogDataCoordinator
    
    convenience init(id: String, dataCoordinator: CatalogDataCoordinator = CatalogDataCoordinator()) {
        self.init(
            id: id,
            dataCoordinator: dataCoordinator,
            analyticsManager: AppConfigurationManager.shared.analyticsManager
        )
    }
    
    init(
        id: String,
        dataCoordinator: CatalogDataCoordinator = CatalogDataCoordinator(),
        analyticsManager: AnalyticsManager?
    ) {
        self.id = id
        self.dataCoordinator = dataCoordinator
        
        itemImageCarouselViewModel = ItemImageCarouselViewModel()
        itemReviewsViewModel = ItemReviewsViewModel()
        
        super.init(analyticsManager: analyticsManager)
    }
    
    func fetchItemDetails() async {
        isLoading = true
        
        do {
            let items = try await dataCoordinator.getItemDetails(id: id)
            itemDetails = items
            
            itemImageCarouselViewModel.configure(imageUrls: items.thumbnails)
            itemReviewsViewModel.configure(reviews: items.reviews ?? [])
        } catch {
            setError(error)
        }
        
        isLoading = false
    }
    
    func toggleFavorite() {
        guard var item = itemDetails else { return }

        item.isFavorited.toggle()
        itemDetails = item
        logFavoriteEvent()
    }
    
    func toggleCart() {
        guard var item = itemDetails else { return }

        item.isAddedToCart.toggle()
        itemDetails = item
        logCartEvent()
    }
    
    private func logFavoriteEvent() {
        guard let itemDetails else { return }
        
        let eventName: AnalyticsEventName = itemDetails.isFavorited
        ? AnalyticsEventName.addToWishlist
        : AnalyticsEventName.removeFromWishlist
        
        logEvent(AnalyticsEvent(
            name: eventName,
            parameters: [.itemId: itemDetails.id, .itemName: itemDetails.name]
        ))
    }
    
    private func logCartEvent() {
        guard let itemDetails else { return }

        let eventName: AnalyticsEventName = itemDetails.isAddedToCart
        ? AnalyticsEventName.addToCart
        : AnalyticsEventName.removeFromCart
        
        logEvent(AnalyticsEvent(
            name: eventName,
            parameters: [.itemId: itemDetails.id, .itemName: itemDetails.name]
        ))
    }
}
