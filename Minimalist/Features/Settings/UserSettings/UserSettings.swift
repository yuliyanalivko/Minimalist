import SwiftUI

@Observable
class UserSettings {
    private let cacheKey = "app_cache_expiration_period"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var cacheExpirationPeriod: CacheExpirationPeriod {
        get {
            guard let rawValue = defaults.string(forKey: cacheKey),
                  let period = CacheExpirationPeriod(rawValue: rawValue) else {
                return .month
            }
            return period
        }
        set {
            defaults.set(newValue.rawValue, forKey: cacheKey)
        }
    }
}
