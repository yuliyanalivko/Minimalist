import Foundation
import Testing
@testable import Minimalist

@MainActor
struct CategoryViewModelTests {
    
    let categories: [Minimalist.Category] = [
        Category(
            id: "1",
            name: "Sofas",
            thumbnailUrl: nil,
            subCategories: [
                SubCategory(
                    id: "3",
                    name: "Kitchen sofas",
                    thumbnailUrl: nil,
                    iconName: nil
                ),
                SubCategory(
                    id: "4",
                    name: "Bedroom sofas",
                    thumbnailUrl: nil,
                    iconName: nil
                )
            ]
        ),
        Category(
            id: "2",
            name: "Tables",
            thumbnailUrl: nil,
            subCategories: []
        ),
    ]
    
    let router: CatalogRouter = CatalogRouter()
    
    private func makeViewModel(
        router: CatalogRouter = CatalogRouter(),
        categoryService: CategoryProviding = MockCategoryProviding(),
        analyticsManager: AnalyticsManager? = nil,
        toastManager: ToastManaging? = nil
    ) -> CategoryViewModel {
        
        if let analyticsManager {
            return CategoryViewModel(router: router, categoryService: categoryService, analyticsManager: analyticsManager, toastManager: toastManager ?? MockToastManager())
        }
        
        if let toastManager {
            return CategoryViewModel(router: router, categoryService: categoryService, analyticsManager: analyticsManager ?? AnalyticsManager(providers: []), toastManager: toastManager)
        }
        
        return CategoryViewModel(router: router, categoryService: categoryService)
    }
    
    @Test("returns all categories when search text is empty")
    func categories_returnAllCategories_emptySearch() {
        let vm = makeViewModel(router: router)
        
        vm.allCategories = categories
        
        #expect(vm.displayedCategories == vm.allCategories)
    }
    
    @Test("returns all categories when search text contains only whitespaces")
    func categories_returnAllCategories_whitespaceSearch() {
        let vm = makeViewModel(router: router)
        
        vm.allCategories = categories
        vm.searchText = "  "
        
        #expect(vm.displayedCategories == vm.allCategories)
    }
    
    @Test("returns filtered categories when search text is not empty")
    func categories_returnAllCategories_nonemptySearch() {
        let vm = makeViewModel(router: router)
        
        vm.allCategories = categories
        vm.searchText = "Sofas"
        
        #expect(vm.displayedCategories == [categories[0]])
    }
    
    @Test("sets selectedCategory")
    func handleCategoryCardClick_setSelectedCategory() {
        let vm = makeViewModel(router: router)
        vm.allCategories = categories
        vm.handleCategoryCardClick(category: categories[0])
        
        #expect(vm.selectedCategory == categories[0])
    }
    
    @Test("calls logEvent with the correct search event")
    func logSearchEvent_callLogEvent() {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(router: router, analyticsManager: analyticsManager)
        
        vm.searchText = " sof "
        
        vm.logSearchEvent()
        
        guard let name = consumer.loggedEvent?.name,
              let parameters = consumer.loggedEvent?.parameters else {
            Issue.record("Expected event to be defined and to have name and parameters")
            
            return
        }
        
        #expect(name == AnalyticsEventName.applySearch.rawValue)
        #expect(parameters[AnalyticsParamName.searchTerm.rawValue] as? String == "sof")
        #expect(parameters[AnalyticsParamName.categoryName.rawValue] == nil)
    }
    
    @Test("Should load categories from service")
    func fetchCategories_success() async {
        let vm = makeViewModel(categoryService: MockCategoryProviding(categories: categories))
        
        await vm.fetchCategories()
        
        #expect(vm.allCategories == categories)
        #expect(vm.loading == false)
        #expect(vm.state == CategoryViewModel.ContentState.content(categories))
    }
    
    @Test("Should set error and shows toast on failure")
    @MainActor
    func fetchCategories_failure() async {
        let testError = NSError(domain: "test", code: 1, userInfo: [
            NSLocalizedDescriptionKey: "Network failed"
        ])
        let toastManager = MockToastManager()
        let vm = makeViewModel(categoryService: MockCategoryProviding(error: testError), toastManager: toastManager)
        
        await vm.fetchCategories()
        
        #expect(vm.error != nil)
        #expect(vm.loading == false)
        #expect(toastManager.current?.message == "Network failed")
        #expect(toastManager.current?.style == .error)
    }
    
    @Test("Should be loading while fetch has not completed")
    func state_isLoading() {
        let vm = makeViewModel()
        vm.loading = true
        
        #expect(vm.state == .loading)
    }
    
    @Test("Should be empty when search has no matches")
    func state_isEmpty() {
        let vm = makeViewModel()
        vm.loading = false
        vm.allCategories = categories
        vm.searchText = "xyz"
        
        #expect(vm.state == .empty)
    }
}
