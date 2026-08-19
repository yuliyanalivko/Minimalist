@testable import Minimalist

let itemDetails = ItemDetails(
    id: "1",
    name: "Sofa",
    category: Category(id: "2", name: "Sofas", thumbnailUrl: nil, subCategories: []),
    subCategory: nil,
    description: "Comfortable sofa",
    rating: 4.5,
    isFavorited: false,
    isAddedToCart: false,
    price: 99.99,
    thumbnails: ["thumb"],
    reviews: [Review(id: "3", rating: 5, message: "Great")]
)
