import SwiftUI

@Observable
class DataAndStorageViewModel {
    private let userSettings: UserSettings

    var selectedExpirationPeriod: CacheExpirationPeriod {
        didSet {
            userSettings.cacheExpirationPeriod = selectedExpirationPeriod
        }
    }
    
    var selectedStorageEngine: CacheStorageEngine {
        didSet {
            userSettings.storageEngine = selectedStorageEngine
        }
    }

    init(userSettings: UserSettings = AppConfigurationManager.shared.userSettings) {
        self.userSettings = userSettings
        self.selectedExpirationPeriod = userSettings.cacheExpirationPeriod
        self.selectedStorageEngine = userSettings.storageEngine
    }
}
