import SwiftUI

@Observable
class CategoryViewModel: RoutableViewModel<CatalogRouter> {
    
    enum ContentState: Equatable {
        case loading
        case content([Category])
        case emptySearch
        case empty
    }
    
    var state: ContentState {
        if loading { return .loading }
        
        guard let categories = displayedCategories else {
            return .empty
        }
        
        if categories.isEmpty {
            return searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? .emptySearch
            : .empty
        }
        
        return .content(categories)
    }
    
    var searchText: String = ""
    var allCategories: [Category]?
    var loading: Bool = true
    
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
    
    var scrollAnchorAligment: UnitPoint {
        guard let categories = displayedCategories else {
            return .center
        }
        
        return state == .content(categories) ? .top : .center
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
        do {
            allCategories =  try await dataCoordinator.getCategories()
        } catch {
            setError(error)
        }
        
        loading = false
    }
    
    func handleCategoryCardClick(category: Category) {
        selectCategory(category)
        router.navigate(to: CatalogRoute.itemList(title: category.name))
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
