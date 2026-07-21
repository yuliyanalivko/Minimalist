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
    private let cartDataCoordinator: CartDataCoordinator
    
    convenience init(
        id: String,
        catalogDataCoordinator: CatalogDataCoordinator = CatalogDataCoordinator(),
        favoritesDataCoordinator: FavoritesDataCoordinator = FavoritesDataCoordinator(),
        cartDataCoordinator: CartDataCoordinator = CartDataCoordinator()
    ) {
        self.init(
            id: id,
            catalogDataCoordinator: catalogDataCoordinator,
            favoritesDataCoordinator: favoritesDataCoordinator,
            cartDataCoordinator: cartDataCoordinator,
            analyticsManager: AppConfigurationManager.shared.analyticsManager
        )
    }
    
    init(
        id: String,
        catalogDataCoordinator: CatalogDataCoordinator = CatalogDataCoordinator(),
        favoritesDataCoordinator: FavoritesDataCoordinator = FavoritesDataCoordinator(),
        cartDataCoordinator: CartDataCoordinator = CartDataCoordinator(),
        analyticsManager: AnalyticsManager?
    ) {
        self.id = id
        self.catalogDataCoordinator = catalogDataCoordinator
        self.favoritesDataCoordinator = favoritesDataCoordinator
        self.cartDataCoordinator = cartDataCoordinator
        
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
            let items = try await catalogDataCoordinator.getItemDetails(id: id)
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
                try await cartDataCoordinator.addToCart(id: item.id)
            } else {
                try await cartDataCoordinator.removeFromCart(id: item.id)
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
