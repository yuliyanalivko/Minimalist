import SwiftUI

@Observable
class CategoryViewModel: BaseViewModel {
    
    var router: CatalogRouter
    var categorySearchText: String = ""
    var subCategorySearchText: String = ""
    var allCategories: [Category] = []
    
    var allSubCategories: [SubCategory]? {
        selectedCategory?.subCategories
    }
    
    let columns = [
        GridItem(.flexible(),spacing: 16),
        GridItem(.flexible(),spacing: 16)
    ]
    
    var selectedSubCategory: SubCategory? {
        allSubCategories?.first {
            $0.id == selectedSubCategoryId
        }
    }
    
    var selectedCategory: Category? {
        allCategories.first(where: { $0.id == selectedCategoryId })
    }
    
    var subCategories: [SubCategory]? {
        guard let subCategories = selectedCategory?.subCategories else {
            return nil
        }
        
        return subCategories.filtered(by: subCategorySearchText, key: \.name)
    }
    
    var categories: [Category] {
        allCategories.filtered(by: categorySearchText, key: \.name)
    }
    
    private var selectedCategoryId: String?
    private var selectedSubCategoryId: String?
    
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
        router.navigate(to: CatalogRoute.subcategory(title: category.name))
    }
    
    func handleSubCategoryCardClick(subCategory: SubCategory) {
        selectSubCategory(subCategory)
        router.navigate(to: CatalogRoute.itemList(title: subCategory.name))
    }
    
    private func selectCategory(_ category: Category) {
        selectedCategoryId = category.id
    }
    
    private func selectSubCategory(_ subCategory: SubCategory) {
        selectedSubCategoryId = subCategory.id
    }
}
