import RealmSwift

class ReviewEntity: EmbeddedObject, Identifiable {
    @Persisted var id: String
    @Persisted var rating: Int
    @Persisted var message: String?
    
    convenience init(from dto: Review) {
        self.init()
        self.id = dto.id
        self.rating = dto.rating
        self.message = dto.message
    }
}
