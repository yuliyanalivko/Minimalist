import SwiftUI

@Observable
class CategoryViewModel: RoutableViewModel<CatalogRouter> {
    var state: ContentState<[Category]> {
        if isLoading { return .loading }
        
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard searchText.isEmpty else {
            return .emptySearch
        }
        
        guard let categories = displayedCategories else {
            return .empty
        }
        
        if categories.isEmpty {
            return searchText.isEmpty
            ? .empty
            : .emptySearch
        }
        
        return .content(categories)
    }
    
    var searchText: String = ""
    var allCategories: [Category]?
    
    let columns = [
        GridItem(.flexible(),spacing: 16),
        GridItem(.flexible(),spacing: 16)
    ]
    
    var selectedCategory: Category? {
        allCategories?.first(where: { $0.id == selectedCategoryId })
    }
    
    var displayedCategories: [Category]? {
        allCategories?.filtered(by: searchText, key: \.name)
    }
    
    private var selectedCategoryId: String?
    private let dataCoordinator: CatalogDataCoordinator
    
    init(
        router: CatalogRouter,
        dataCoordinator: CatalogDataCoordinator = CatalogDataCoordinator(),
        analyticsManager: AnalyticsManager? = nil
    ) {
        self.dataCoordinator = dataCoordinator
        super.init(router: router, analyticsManager: analyticsManager)
    }
    
    convenience init(
        router: CatalogRouter,
        dataCoordinator: CatalogDataCoordinator = CatalogDataCoordinator()
    ) {
        self.init(
            router: router,
            dataCoordinator: dataCoordinator,
            analyticsManager: AppConfigurationManager.shared.analyticsManager
        )
    }
    
    func fetchCategories() async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            allCategories =  try await dataCoordinator.getCategories()
        } catch {
            setError(error)
        }
    }
    
    func handleCategoryCardClick(category: Category) {
        selectCategory(category)
        router.navigate(to: CatalogRoute.itemList(title: category.name, id: category.id))
    }
    
    func logSearchEvent() {
        let searchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !searchTerm.isEmpty else { return }
        
        logEvent(AnalyticsEvent(
            name: .applySearch,
            parameters: [.searchTerm: searchTerm]
        ))
    }
    
    private func selectCategory(_ category: Category) {
        selectedCategoryId = category.id
    }
}
