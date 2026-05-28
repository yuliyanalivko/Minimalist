import SwiftUI

@Observable
class CategoryViewModel: BaseViewModel {
    
    var router: CatalogRouter
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
    
    init(router: CatalogRouter) {
        self.router = router
        super.init()
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
        
        logEvent(
            FirebaseAnalyticsEvent.applySearch(
                searchTerm: searchTerm,
                categoryName: nil,
            )
        )
    }
}
