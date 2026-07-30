enum CacheExpirationPeriod: String, CaseIterable, Identifiable {
    case day
    case week
    case month
    case never
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .day:
            return "1 Day"
        case .week:
            return "1 Week"
        case .month:
            return "30 days"
        case .never:
            return "Never"
        }
    }
    
    var days: Int? {
        switch self {
        case .day:
            return 1
        case .week:
            return 7
        case .month:
            return 30
        case .never:
            return nil
        }
    }
}
