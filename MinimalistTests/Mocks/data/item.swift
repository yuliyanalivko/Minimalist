@testable import Minimalist

let item = Item(
    id: "1",
    name: "Sofa",
    category: Category(
        id: "2",
        name: "Sofas",
        thumbnailUrl: nil,
        subCategories: []
    ),
    subcategory: nil,
    rating: 4.5,
    isFavorited: false,
    isAddedToCart: false,
    price: 99.99,
    thumbnailUrl: nil
)

let item2 = Item(
    id: "2",
    name: "Solklint",
    category: Category(
        id: "1",
        name: "Tables",
        thumbnailUrl: nil,
        subCategories: []
    ),
    subcategory: nil,
    rating: 5.5,
    isFavorited: false,
    isAddedToCart: true,
    price: 20.50,
    thumbnailUrl: "https://example.com/id/1041/500/500"
)
