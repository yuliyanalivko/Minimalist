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
        
        vm.categories = categories
        
        #expect(vm.view == .category)
    }
    
    @Test("returns View.subategory when category is selected")
    func view_setToSubCategory_categorySelected() {
        let vm = CatalogViewModel()
        
        vm.categories = categories
        vm.select(categories[0])

        #expect(vm.view == .subCategory)
    }
    
    @Test("returns categories when category is not selected")
    func itemsToShow_returnCategories_categoryUnselected() {
        let vm = CatalogViewModel()
        
        vm.categories = categories

        #expect(vm.itemsToShow.compactMap { $0 as? Category } == vm.categories)
    }
    
    @Test("returns subCategory when category is selected")
    func itemsToShow_returnSubcategories_categorySelected() {
        let vm = CatalogViewModel()
        
        vm.categories = categories
        vm.select(categories[0])

        #expect(vm.itemsToShow.compactMap { $0 as? SubCategory } == vm.categories[0].subCategories)
    }
    
    @Test("returns subCategory array of the selected category")
    func subCategories_returnArray_categorySelected() {
        let vm = CatalogViewModel()
        
        vm.categories = categories
        vm.select(categories[0])
        
        #expect(vm.subCategories == categories.first!.subCategories)
    }
    
    @Test("returns nil when category is not selected")
    func subCategories_returnNil_categoryNotSelected() {
        let vm = CatalogViewModel()
        
        vm.categories = categories
        
        #expect(vm.subCategories == nil)
    }
    
    @Test("returns selectedCategory")
    func selectCategory_setSelectedCategory() {
        let vm = CatalogViewModel()
        
        vm.categories = categories
        vm.select(categories[0])
        
        #expect(vm.selectedCategory == categories[0])
    }
    
    @Test("returns selectedSubCategory")
    func subCategories_returnArray_setSelectedSubCategory() {
        let vm = CatalogViewModel()
        
        vm.categories = categories
        vm.select(categories[0])
        vm.select(categories[0].subCategories[0])
        
        #expect(vm.selectedSubCategory == categories[0].subCategories[0])
    }
}
