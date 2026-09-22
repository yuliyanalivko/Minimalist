import Foundation
import SwiftUI

@Observable
class CartListViewModel: RoutableViewModel<CartRouter> {
    var allItems: [Item] = []
    var searchText: String = ""
    
    var selectedIds = Set<String>()
    
    var displayedItems: [Item] {
        allItems.filtered(by: searchText, key: \.name)
    }
    
    var state: ContentState<[Item]> {
        if isLoading { return .loading }
        
        if displayedItems.isEmpty {
            return searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? .empty
            : .emptySearch
        }
        
        return .content(displayedItems)
    }

    var isSelectionMode: Bool {
        !selectedIds.isEmpty
    }
    
    var totalPrice: Double {
        selectedItems
            .reduce(0.0) { $0 + $1.price }
    }
    
    private var selectedItems: [Item] {
        allItems
            .filter { isSelectionMode ? selectedIds.contains($0.id) : true }
    }
    
    private let cartService: CartService

    init(
        router: CartRouter,
        cartService: CartService = CartService(),
        analyticsManager: AnalyticsManager? = nil
    ) {
        self.cartService = cartService
        super.init(router: router, analyticsManager: analyticsManager)
    }
    
    func fetchCartItems() async {
        if allItems.isEmpty == true {
            isLoading = true
        }
        
        defer {
            isLoading = false
        }
        
        do {
            for try await items in cartService.getCartItems() {
                allItems = mapUrls(of: items)
            }
            
            selectedIds = selectedIds.filter(Set(allItems.map { $0.id }).contains)
                     
            isLoading = false

        } catch {
            setError(error)
        }
    }
        
    func removeFromCart(_ item: Item) async {
        if let index = allItems.firstIndex(where: { $0.id == item.id }) {
            do {
                try await cartService.removeFromCart(id: item.id)

                logRemoveFromCartEvent(item: allItems[index])
                allItems.remove(at: index)
            } catch {
                setError(error)
            }
        }
    }
    
    func handleItemLongPress(item: Item) {
        selectedIds.insert(item.id)
    }
    
    func handleItemClick(item: Item) {
        guard isSelectionMode else {
            router.navigate(to: CartRoute.itemDetails(title: item.name, id: item.id))
            
            return
        }
        
        toggleSelection(for: item.id)
    }
    
    func handleBuyButtonClick() {
        router.navigate(to: CartRoute.checkout(items: selectedItems))
        logBeginCheckoutEvent()
    }
    
    func resetSelection() {
        selectedIds = []
    }
    
    func logSearchEvent() {
        let searchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !searchTerm.isEmpty else { return }
        
        logEvent(AnalyticsEvent(
            name: AnalyticsEventName.applySearch,
            parameters: [AnalyticsParamName.searchTerm: searchTerm]
        ))
    }
    
    private func logRemoveFromCartEvent(item: Item) {
        logEvent(AnalyticsEvent(
            name: AnalyticsEventName.removeFromCart,
            parameters: [.itemId: item.id, .itemName: item.name]
        ))
    }
    
    private func logBeginCheckoutEvent() {
        logEvent(AnalyticsEvent(
            name: AnalyticsEventName.beginCheckout,
            parameters: [.quantity: selectedItems.count, .items: selectedItems.map { $0.id }]
        ))
    }
    
    private func toggleSelection(for id: String) {
        if selectedIds.contains(id) {
            selectedIds.remove(id)
        } else {
            selectedIds.insert(id)
        }
    }
    
    private func mapUrls(of items: [Item]) -> [Item] {
        URLHelper.mapUrls(of: items, keyPath: \.thumbnailUrl)
    }
}
