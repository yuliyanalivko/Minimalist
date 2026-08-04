import Testing
@testable import Minimalist

struct CacheExpirationPeriodTests {
    
    @Test("Title property returns expected display string", arguments: [
        (CacheExpirationPeriod.day, "1 Day"),
        (CacheExpirationPeriod.week, "1 Week"),
        (CacheExpirationPeriod.month, "30 days"),
        (CacheExpirationPeriod.never, "Never")
    ])
    func title(period: CacheExpirationPeriod, expectedTitle: String) {
        #expect(period.title == expectedTitle)
    }

    @Test("Days property returns correct day count or nil", arguments: [
        (CacheExpirationPeriod.day, Optional(1)),
        (CacheExpirationPeriod.week, Optional(7)),
        (CacheExpirationPeriod.month, Optional(30)),
        (CacheExpirationPeriod.never, nil)
    ])
    func days(period: CacheExpirationPeriod, expectedDays: Int?) {
        #expect(period.days == expectedDays)
    }

    @Test("ID matches self instance for Identifiable conformance")
    func idMatchesSelf() {
        for period in CacheExpirationPeriod.allCases {
            #expect(period.id == period)
        }
    }
}
