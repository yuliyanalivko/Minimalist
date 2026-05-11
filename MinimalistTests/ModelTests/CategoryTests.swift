import Testing
@testable import Minimalist

struct CategoryTests {
    @Test("return correct icon name", arguments: [
        ("Sofas", "couch"),
        ("Chairs", "chair"),
        ("Tables", "table"),
        ("Lamps", "lamp"),
        ("Beds", "bed"),
        ("Wardrobes", "wardrobe"),
        ("NonExistent", nil)
    ])
    func iconName_returnCorrectIcon(name: String, expectedIcon: String?) {
        let category = Category(
            id: "id",
            name: name,
            thumbnailUrl: nil,
            subCategories: []
        )
        
        #expect(category.iconName == expectedIcon)
    }
}
