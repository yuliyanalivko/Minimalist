struct Review: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let rating: Int
    let message: String?
    
    func toEntity() -> ReviewEntity {
        ReviewEntity(from: self)
    }
}

extension Review {
    init(from entity: ReviewEntity) {
        self.init(
            id: entity.id,
            rating: entity.rating,
            message: entity.message,
        )
    }
}
