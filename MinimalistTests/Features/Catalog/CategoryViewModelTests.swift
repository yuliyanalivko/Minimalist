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

    private func makeViewModel(
        handler: MockURLProtocol.Handler? = nil,
        analyticsManager: AnalyticsManager? = nil
    ) -> CategoryViewModel {
        let resolvedHandler: MockURLProtocol.Handler = handler ?? { request in
            (TestHTTPClientFactory.httpResponse(for: request, statusCode: 200), mockCategories.data(using: .utf8)!)
        }

        let httpClient = TestHTTPClientFactory.make(handler: resolvedHandler)

        let categoryService = CategoryService(
            client: CatalogDataProvider(
                httpClient: HTTPCatalogClient(client: httpClient)
            )
        )

        if let analyticsManager {
            return CategoryViewModel(
                router: CatalogRouter(),
                categoryService: categoryService,
                analyticsManager: analyticsManager
            )
        }

        return CategoryViewModel(router: CatalogRouter(), categoryService: categoryService)
    }

    @Test("returns all categories when search text is empty")
    func categories_returnAllCategories_emptySearch() {
        let vm = makeViewModel()

        vm.allCategories = categories

        #expect(vm.displayedCategories == vm.allCategories)
    }

    @Test("returns all categories when search text contains only whitespaces")
    func categories_returnAllCategories_whitespaceSearch() {
        let vm = makeViewModel()

        vm.allCategories = categories
        vm.searchText = "  "

        #expect(vm.displayedCategories == vm.allCategories)
    }

    @Test("returns filtered categories when search text is not empty")
    func categories_returnAllCategories_nonemptySearch() {
        let vm = makeViewModel()

        vm.allCategories = categories
        vm.searchText = "Sofas"

        #expect(vm.displayedCategories == [categories[0]])
    }

    @Test("sets selectedCategory")
    func handleCategoryCardClick_setSelectedCategory() {
        let vm = makeViewModel()
        vm.allCategories = categories
        vm.handleCategoryCardClick(category: categories[0])

        #expect(vm.selectedCategory == categories[0])
    }

    @Test("calls logEvent with the correct search event")
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
    func fetchCategories_success() async {
        let json = mockCategories.data(using: .utf8)!
        let expected = try! JSONDecoder().decode([Minimalist.Category].self, from: json)

        let vm = makeViewModel { request in
            #expect(request.url?.path == "/api/v1/categories")
            #expect(request.httpMethod == "GET")

            return (TestHTTPClientFactory.httpResponse(for: request, statusCode: 200), json)
        }

        await vm.fetchCategories()

        #expect(vm.allCategories == expected)
        #expect(vm.loading == false)
        #expect(vm.state == CategoryViewModel.ContentState.content(expected))
    }

    @Test("Should set error on failure")
    func fetchCategories_failure() async {
        let vm = makeViewModel { request in
            (TestHTTPClientFactory.httpResponse(for: request, statusCode: 500), Data())
        }

        await vm.fetchCategories()

        #expect(vm.error != nil)
        #expect(vm.loading == false)
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
