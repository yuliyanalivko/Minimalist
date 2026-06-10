import SwiftUI

@Observable
class CategoryViewModel: RoutableViewModel<CatalogRouter> {
    
    var searchText: String = ""
    var allCategories: [Category] = []
    
    let columns = [
        GridItem(.flexible(),spacing: 16),
        GridItem(.flexible(),spacing: 16)
    ]
    
    var selectedCategory: Category? {
        allCategories.first(where: { $0.id == selectedCategoryId })
    }
    
    var displayedCategories: [Category] {
        allCategories.filtered(by: searchText, key: \.name)
    }
    
    private var selectedCategoryId: String?
    
    override init(router: CatalogRouter) {
        super.init(router: router)
        // TODO: remove when CategoryService is implemented
        loadMock()
    }
    
    override init(router: CatalogRouter, analyticsManager: AnalyticsManager) {
        super.init(router: router, analyticsManager: analyticsManager)
        // TODO: remove when CategoryService is implemented
        loadMock()
    }
    
    // TODO: TODO: remove when CategoryService is implemented
    func loadMock() {
        let data = categoriesMock.data(using: .utf8)!
        allCategories = try! JSONDecoder().decode([Category].self, from: data)
    }
    
    func handleCategoryCardClick(category: Category) {
        selectCategory(category)
        router.navigate(to: CatalogRoute.itemList(title: category.name))
    }

    private func selectCategory(_ category: Category) {
        selectedCategoryId = category.id
    }
    
    func logSearchEvent() {
        let searchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !searchTerm.isEmpty else { return }
        
        logEvent(AnalyticsEvent(
            name: .applySearch,
            parameters: [.searchTerm: searchTerm]
        ))
    }
}
