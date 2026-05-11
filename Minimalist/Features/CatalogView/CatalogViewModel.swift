import SwiftUI

@Observable
class CatalogViewModel {
    enum DisplayMode {
        case category
        case subCategory
    }
    
    var categories: [Category] = []
    private var selectedCategoryId: String?
    private var selectedSubCategoryId: String?
    
    var selectedCategory: Category? {
        categories.first(where: { $0.id == selectedCategoryId })
    }
    
    var selectedSubCategory: SubCategory? {
        subCategories?.first {
            $0.id == selectedSubCategoryId
        }
    }
    
    var subCategories: [SubCategory]? {
        selectedCategory?.subCategories
    }
    
    var itemsToShow: [any CatalogItemConfigurable] {
        subCategories ?? categories
    }
    
    var displayMode: DisplayMode {
        selectedCategory == nil ? .category : .subCategory
    }
    
    let columns = [
        GridItem(.flexible(),spacing: 16),
        GridItem(.flexible(),spacing: 16)
    ]
    
    init() {
        // TODO: remove when CategoryService is implemented
        loadMock()
    }
    
    // TODO: TODO: remove when CategoryService is implemented
    func loadMock() {
        let data = categoriesMock.data(using: .utf8)!
        categories = try! JSONDecoder().decode([Category].self, from: data)
    }
    
    func select(_ item: any CatalogItemConfigurable) {
        if displayMode == .category, let category = item as? Category {
            selectCategory(category)
        } else if let subCategory = item as? SubCategory {
            selectSubCategory(subCategory)
        }
    }
    
    private func selectCategory(_ category: Category) {
        selectedCategoryId = category.id
    }
    
    private func selectSubCategory(_ subCategory: SubCategory) {
        selectedSubCategoryId = subCategory.id
    }
}
