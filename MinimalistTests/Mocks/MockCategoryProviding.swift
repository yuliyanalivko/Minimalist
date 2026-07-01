@testable import Minimalist

struct MockCategoryProviding: CategoryProviding {
    let categories: [Category]
    let error: Error?
    
    init(categories: [Category] = [], error: Error? = nil) {
        self.categories = categories
        self.error = error
    }
    
    func getCategories() async throws -> [Category] {
        if let error { throw error }
        
        return categories
    }
}
