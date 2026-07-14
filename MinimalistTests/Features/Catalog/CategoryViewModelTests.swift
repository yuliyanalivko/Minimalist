import Foundation
import Testing
@testable import Minimalist

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

    @MainActor
    private func makeViewModel(
        mockData: Data? = mockCategories.data(using: .utf8),
        mockError: Error? = nil,
        analyticsManager: AnalyticsManager? = nil
    ) -> CategoryViewModel {
        let mockClient = MockNetworkClient(mockData: mockData, mockError: mockError)
        let coordinator = CatalogDataCoordinator(
            networkService: CatalogNetworkService(networkClient: mockClient)
        )

        if let analyticsManager {
            return CategoryViewModel(
                router: CatalogRouter(),
                dataCoordinator: coordinator,
                analyticsManager: analyticsManager
            )
        }

        return CategoryViewModel(router: CatalogRouter(), dataCoordinator: coordinator)
    }

    @Test("returns all categories when search text is empty")
    @MainActor
    func categories_returnAllCategories_emptySearch() {
        let vm = makeViewModel()

        vm.allCategories = categories

        #expect(vm.displayedCategories == vm.allCategories)
    }

    @Test("returns all categories when search text contains only whitespaces")
    @MainActor
    func categories_returnAllCategories_whitespaceSearch() {
        let vm = makeViewModel()

        vm.allCategories = categories
        vm.searchText = "  "

        #expect(vm.displayedCategories == vm.allCategories)
    }

    @Test("returns filtered categories when search text is not empty")
    @MainActor
    func categories_returnAllCategories_nonemptySearch() {
        let vm = makeViewModel()

        vm.allCategories = categories
        vm.searchText = "Sofas"

        #expect(vm.displayedCategories == [categories[0]])
    }

    @Test("sets selectedCategory")
    @MainActor
    func handleCategoryCardClick_setSelectedCategory() {
        let vm = makeViewModel()
        vm.allCategories = categories
        vm.handleCategoryCardClick(category: categories[0])

        #expect(vm.selectedCategory == categories[0])
    }

    @Test("calls logEvent with the correct search event")
    @MainActor
    func logSearchEvent_callLogEvent() {
        let consumer = MockAnalyticsConsumer()
        let provider = FirebaseAnalyticsProvider(consumer: consumer)
        let analyticsManager = AnalyticsManager(providers: [provider])
        let vm = makeViewModel(analyticsManager: analyticsManager)

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
    @MainActor
    func fetchCategories_success() async {
        let json = mockCategories.data(using: .utf8)!
        let expected = try! JSONDecoder().decode([Minimalist.Category].self, from: json)

        let vm = makeViewModel(mockData: json)

        await vm.fetchCategories()

        #expect(vm.allCategories == expected)
        #expect(vm.isLoading == false)
        #expect(vm.state == ContentState.content(expected))
    }

    @Test("Should set error on failure")
    @MainActor
    func fetchCategories_failure() async {
        let vm = makeViewModel(mockError: URLError(.badServerResponse))

        await vm.fetchCategories()

        #expect(vm.error != nil)
        #expect(vm.errorMessage == "The server returned an unexpected response. Please try again later.")
        #expect(vm.isLoading == false)
    }

    @Test("Should be loading while fetch has not completed")
    @MainActor
    func state_loading_fetchHasNotCompleted() {
        let vm = makeViewModel()
        vm.isLoading = true

        #expect(vm.state == .loading)
    }

    @Test("Should be emptySearch when search has no matches")
    @MainActor
    func state_emptySearch_searchHasNoMatches() {
        let vm = makeViewModel()
        vm.isLoading = false
        vm.allCategories = categories
        vm.searchText = "xyz"

        #expect(vm.state == .emptySearch)
    }
    
    @Test("Should be emptySearch when searchText is not empty and categories are not fetched")
    @MainActor
    func state_emptySearch_searchIsNotEmptyAndCategoriesIsNil() {
        let vm = makeViewModel()
        vm.isLoading = false
        vm.searchText = "xyz"

        #expect(vm.state == .emptySearch)
    }
}
