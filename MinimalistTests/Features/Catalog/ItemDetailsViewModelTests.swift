import Testing
@testable import Minimalist

struct ItemDetailsViewModelTests {
    
    let item: ItemDetails =
        ItemDetails(
            id: "1",
            name: "Vindkast",
            category: Category(
                id: "2",
                name: "Tables",
                thumbnailUrl: nil,
                subCategories: []
            ),
            subCategory: nil,
            description: "Description",
            rating: 2.5,
            isFavorited: false,
            isAddedToCart: false,
            price: 10.50,
            thumbnails: ["https://example.com/id/1041/5184/2916"],
            reviews: []
        )
    
    @Test("Should set isFavorite to true")
    func toggleFavorite_setToTrue(){
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = ItemDetailsViewModel(id: "1", analyticsManager: analyticsManager)
        vm.itemDetails = item
        
        vm.toggleFavorite()
        
        #expect(vm.itemDetails.isFavorited)
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")
            
            return
        }
        
        #expect(name == AnalyticsEventName.addToWishlist.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == item.id)
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == item.name)
    }
    
    @Test("Should set isFavorite to false")
    func toggleFavorite_setToFalse(){
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = ItemDetailsViewModel(id: "1", analyticsManager: analyticsManager)
        vm.itemDetails = item
        vm.itemDetails.isFavorited = true
        
        vm.toggleFavorite()
        
        #expect(!vm.itemDetails.isFavorited)
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")
            
            return
        }
        
        #expect(name == AnalyticsEventName.removeFromWishlist.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == item.id)
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == item.name)
    }
    
    @Test("Should set isAddedToCart to true")
    func toggleCart_setToTrue(){
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = ItemDetailsViewModel(id: "1", analyticsManager: analyticsManager)
        vm.itemDetails = item
        
        vm.toggleCart()
        
        #expect(vm.itemDetails.isAddedToCart)
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")
            
            return
        }
        
        #expect(name == AnalyticsEventName.addToCart.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == item.id)
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == item.name)
    }
    
    @Test("Should set isAddedToCart to false")
    func toggleCart_setToFalse(){
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = ItemDetailsViewModel(id: "1", analyticsManager: analyticsManager)
        vm.itemDetails = item
        vm.itemDetails.isAddedToCart = true
        
        vm.toggleCart()
        
        #expect(!vm.itemDetails.isAddedToCart)
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")
            
            return
        }
        
        #expect(name == AnalyticsEventName.removeFromCart.rawValue)
        #expect(parameters[AnalyticsParamName.itemId.rawValue] as? String == item.id)
        #expect(parameters[AnalyticsParamName.itemName.rawValue] as? String == item.name)
    }
}
