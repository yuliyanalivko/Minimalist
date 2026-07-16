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
        
        defer {
            isLoading = false
        }
        
        do {
            let items = try await dataCoordinator.getItemDetails(id: id)
            itemDetails = items
            
            itemImageCarouselViewModel.configure(imageUrls: items.thumbnails)
            itemReviewsViewModel.configure(reviews: items.reviews ?? [])
        } catch {
            setError(error)
        }
    }
    
    func toggleFavorite() async {
        guard var item = itemDetails else { return }

        item.isFavorited.toggle()
        itemDetails = item
        
        do {
            let toggleFavorite = item.isFavorited
            ? dataCoordinator.addToFavorites
            : dataCoordinator.removeFromFavorites
            
            try await toggleFavorite(item.id)
            
            logFavoriteEvent()
        } catch {
            item.isFavorited.toggle()
            itemDetails = item
            
            setError(error)
        }
    }
    
    func toggleCart() async {
        guard var item = itemDetails else { return }
        
        item.isAddedToCart.toggle()
        itemDetails = item

        do {
            let toggleCart = item.isAddedToCart
            ? dataCoordinator.addToCart
            : dataCoordinator.removeFromCart
            
            try await toggleCart(item.id)

            logCartEvent()
        } catch {
            item.isAddedToCart.toggle()
            itemDetails = item
            
            setError(error)
        }
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
