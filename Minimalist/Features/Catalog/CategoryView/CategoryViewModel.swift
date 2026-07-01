import SwiftUI

@Observable
class CategoryViewModel: RoutableViewModel<CatalogRouter> {
    
    @ObservationIgnored
    @Injected private var categoryService: CategoryProviding
    
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
    
    private var selectedCategoryId: String?
    
    func fetchCategories() async {
        do {
            allCategories = try await categoryService.getCategories()
        } catch {
            setError(error)
            showToast(message: error.localizedDescription, style: .error)
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
