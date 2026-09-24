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
    private let catalogDataCoordinator: CatalogDataCoordinator
    private let favoritesDataCoordinator: FavoritesDataCoordinator
    private let cartService: CartService
    
    convenience init(
        id: String,
        catalogDataCoordinator: CatalogDataCoordinator = CatalogDataCoordinator(),
        favoritesDataCoordinator: FavoritesDataCoordinator = FavoritesDataCoordinator(),
        cartService: CartService = CartService()
    ) {
        self.init(
            id: id,
            catalogDataCoordinator: catalogDataCoordinator,
            favoritesDataCoordinator: favoritesDataCoordinator,
            cartService: cartService,
            analyticsManager: AppConfigurationManager.shared.analyticsManager
        )
    }
    
    init(
        id: String,
        catalogDataCoordinator: CatalogDataCoordinator = CatalogDataCoordinator(),
        favoritesDataCoordinator: FavoritesDataCoordinator = FavoritesDataCoordinator(),
        cartService: CartService = CartService(),
        analyticsManager: AnalyticsManager?
    ) {
        self.id = id
        self.catalogDataCoordinator = catalogDataCoordinator
        self.favoritesDataCoordinator = favoritesDataCoordinator
        self.cartService = cartService
        
        itemImageCarouselViewModel = ItemImageCarouselViewModel()
        itemReviewsViewModel = ItemReviewsViewModel()
        
        super.init(analyticsManager: analyticsManager)
    }
    
    func fetchItemDetails() async {
        if itemDetails == nil {
            isLoading = true
        }
        
        defer {
            isLoading = false
        }
        
        do {
            for try await item in catalogDataCoordinator.getItemDetails(id: id) {
                itemDetails = item
                
                itemImageCarouselViewModel.configure(imageUrls: item.thumbnails)
                itemReviewsViewModel.configure(reviews: item.reviews ?? [])

                isLoading = false
            }
        } catch {
            setError(error)
        }
    }
    
    func toggleFavorite() async {
        guard var item = itemDetails else { return }
        
        item.isFavorited.toggle()
        itemDetails = item
        
        do {
            if item.isFavorited {
                try await favoritesDataCoordinator.addToFavorites(id: item.id)
            } else {
                try await favoritesDataCoordinator.removeFromFavorites(id: item.id)
            }
            
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
            if item.isAddedToCart {
                try await cartService.addToCart(id: item.id)
            } else {
                try await cartService.removeFromCart(id: item.id)
            }
            
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
