import SwiftUI

@Observable
class UserSettings {
    private let cacheKey: String = UserDefaultsKey.cacheExpirationPeriod.rawValue
    private let storageEngineKey: String = UserDefaultsKey.cacheStorageEngine.rawValue
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
    
    var storageEngine: CacheStorageEngine {
        get {
            guard let rawValue = defaults.string(forKey: storageEngineKey),
                  let engine = CacheStorageEngine(rawValue: rawValue) else {
                return .realm
            }
            return engine
        }
        set {
            defaults.set(newValue.rawValue, forKey: storageEngineKey)
        }
    }
}
