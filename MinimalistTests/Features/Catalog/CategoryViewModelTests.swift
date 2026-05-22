import Testing
@testable import Minimalist

@MainActor
struct CategoryViewModelTests {
    let categories: [Category] = [
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
    
    let router: CatalogRouter = CatalogRouter()
    
    @Test("returns all categories when search text is empty")
    func categories_returnAllCategories_emptySearch() {
        let vm = CategoryViewModel(router: router)
        
        vm.allCategories = categories

        #expect(vm.categories == vm.allCategories)
    }
    
    @Test("returns all categories when search text contains only whitespaces")
    func categories_returnAllCategories_whitespaceSearch() {
        let vm = CategoryViewModel(router: router)
        
        vm.allCategories = categories
        vm.categorySearchText = "  "

        #expect(vm.categories == vm.allCategories)
    }
    
    @Test("returns filtered categories when search text is not empty")
    func categories_returnAllCategories_nonemptySearch() {
        let vm = CategoryViewModel(router: router)
        
        vm.allCategories = categories
        vm.categorySearchText = "Sofas"

        #expect(vm.categories == [vm.allCategories[0]])
    }
    
    @Test("sets selectedCategory")
    func handleCategoryCardClick_setSelectedCategory() {
        let vm = CategoryViewModel(router: router)
        
        vm.allCategories = categories
        vm.handleCategoryCardClick(category: categories[0])
        
        #expect(vm.selectedCategory == categories[0])
    }
}
