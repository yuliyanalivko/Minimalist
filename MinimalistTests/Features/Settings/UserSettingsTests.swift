import Testing
@testable import Minimalist

struct UserSettingsTests {
    
    @Test("Default cache expiration period is set to month")
    func defaultCacheExpirationPeriod() {
        let settings = UserSettings()
        
        #expect(settings.cacheExpirationPeriod == .month)
    }
}
