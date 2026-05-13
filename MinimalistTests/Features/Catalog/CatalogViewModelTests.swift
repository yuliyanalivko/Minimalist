import Testing
@testable import Minimalist

@MainActor
struct CatalogViewModelTests {
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
    
    @Test("returns View.category when category is not selected")
    func view_setToCategory_categoryNotSelected() {
        let vm = CatalogViewModel()
        
        vm.allCategories = categories
        
        #expect(vm.displayMode == .category)
    }
    
    @Test("returns View.subategory when category is selected")
    func view_setToSubCategory_categorySelected() {
        let vm = CatalogViewModel()
        
        vm.allCategories = categories
        vm.select(categories[0])

        #expect(vm.displayMode == .subCategory)
    }
    
    @Test("returns all categories when search text is empty")
    func categories_returnAllCategories_emptySearch() {
        let vm = CatalogViewModel()
        
        vm.allCategories = categories

        #expect(vm.categories == vm.allCategories)
    }
    
    @Test("returns all categories when search text contains only whitespaces")
    func categories_returnAllCategories_whitespaceSearch() {
        let vm = CatalogViewModel()
        
        vm.allCategories = categories
        vm.categorySearchText = "  "

        #expect(vm.categories == vm.allCategories)
    }
    
    @Test("returns filtered categories when search text is not empty")
    func categories_returnAllCategories_nonemptySearch() {
        let vm = CatalogViewModel()
        
        vm.allCategories = categories
        vm.categorySearchText = "Sofas"

        #expect(vm.categories == [vm.allCategories[0]])
    }
    
    @Test("returns all subcategories when search text is empty")
    func subCategories_returnAllSubCategories_emptySearch() {
        let vm = CatalogViewModel()
        
        vm.allCategories = categories
        vm.select(categories[0])

        #expect(vm.subCategories == vm.allCategories[0].subCategories)
    }
    
    @Test("returns all categories when search text contains only whitespaces")
    func subCategories_returnAllSubCategories_whitespaceSearch() {
        let vm = CatalogViewModel()
        
        vm.allCategories = categories
        vm.select(categories[0])
        vm.subCategorySearchText = "  "

        #expect(vm.subCategories == vm.allCategories[0].subCategories)
    }
    
    @Test("returns filtered subcategories when search text is not empty")
    func subCategories_returnAllSubCategories_nonemptySearch() {
        let vm = CatalogViewModel()
        
        vm.allCategories = categories
        vm.select(categories[0])
        vm.subCategorySearchText = "Kitchen"

        #expect(vm.subCategories == [vm.allCategories[0].subCategories[0]])
    }
    
    @Test("returns nil when category is not selected")
    func subCategories_returnNil_categoryNotSelected() {
        let vm = CatalogViewModel()
        
        vm.allCategories = categories
        
        #expect(vm.subCategories == nil)
    }
    
    @Test("returns selectedCategory")
    func selectCategory_setSelectedCategory() {
        let vm = CatalogViewModel()
        
        vm.allCategories = categories
        vm.select(categories[0])
        
        #expect(vm.selectedCategory == categories[0])
    }
    
    @Test("returns selectedSubCategory")
    func subCategories_returnArray_setSelectedSubCategory() {
        let vm = CatalogViewModel()
        
        vm.allCategories = categories
        vm.select(categories[0])
        vm.select(categories[0].subCategories[0])
        
        #expect(vm.selectedSubCategory == categories[0].subCategories[0])
    }
}
