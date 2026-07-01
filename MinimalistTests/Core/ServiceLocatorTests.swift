import Testing
@testable import Minimalist

struct ServiceLocatorTests {
    
    private let locator = ServiceLocator.shared
    
    private func reset() {
        try? locator.unregister(CategoryProviding.self)
    }
    
    @Test("Should throw duplicateService when type is already registered")
    func register_throwOnDuplicate() throws {
        reset()
        try locator.register(service: StubCategoryProviding() as CategoryProviding)
        
        #expect(throws: ServiceLocator.ServiceError.duplicateService(serviceName: "CategoryProviding")) {
            try locator.register(service: StubCategoryProviding() as CategoryProviding)
        }
        reset()
    }
    
    @Test("Should remove a registered service")
    func unregister_removeService() throws {
        reset()
        try locator.register(service: StubCategoryProviding() as CategoryProviding)
        try locator.unregister(CategoryProviding.self)
        
        #expect(throws: ServiceLocator.ServiceError.inexistentService(serviceName: "CategoryProviding")) {
            try locator.unregister(CategoryProviding.self)
        }
    }
}
