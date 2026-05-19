import Testing
@testable import Minimalist

@MainActor
struct CatalogViewModelTests {
    
    @Test("sets up shared router instance correctly")
    func init_setsUpSharedRouter() async throws {
        let vm = CatalogViewModel()
        
        #expect(vm.categoryViewModel.router === vm.router, "CategoryViewModel should share the main router instance")
        #expect(vm.itemListViewModel.router === vm.router, "ItemListViewModel should share the main router instance")
    }
}
