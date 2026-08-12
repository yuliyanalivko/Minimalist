enum CacheStorageEngine: String, CaseIterable, Identifiable {
    case swiftData
    case realm
    
    var id: Self { self }

    var title: String {
        switch self {
        case .swiftData:
            return "SwiftData"
        case .realm:
            return "Realm"
        }
    }
}
