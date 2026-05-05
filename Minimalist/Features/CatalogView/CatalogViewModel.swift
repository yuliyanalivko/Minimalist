import SwiftUI

@Observable
class CatalogViewModel {
    enum View {
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
    
    var view: View {
        selectedCategory == nil ? .category : .subCategory
    }
    
    var subCategories: [SubCategory]? {
        selectedCategory?.subCategories
    }
    
    init() {
        // TODO: remove when CategoryService is implemented
        loadMock()
    }
    
    // TODO: TODO: remove when CategoryService is implemented
    func loadMock() {
        let data = categoriesMock.data(using: .utf8)!
        categories = try! JSONDecoder().decode([Category].self, from: data)
    }
    
    func selectCategory(_ category: Category) {
        selectedCategoryId = category.id
    }
    
    func selectSubCategory(_ subCategory: SubCategory) {
        selectedSubCategoryId = subCategory.id
    }
}
