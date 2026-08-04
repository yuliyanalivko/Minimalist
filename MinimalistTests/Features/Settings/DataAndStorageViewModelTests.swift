import Testing
import Foundation
@testable import Minimalist

struct DataAndStorageViewModelTests {

    private func makeSettings() -> UserSettings {
        let suiteName = "DataAndStorageViewModelTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        
        return UserSettings(defaults: defaults)
    }

    @Test("Initialization loads stored expiration period from UserSettings")
    func initialization_loadsStoredValue() {
        let settings = makeSettings()
        settings.cacheExpirationPeriod = .week

        let viewModel = DataAndStorageViewModel(userSettings: settings)

        #expect(viewModel.selectedExpirationPeriod == .week)
    }

    @Test("Initialization defaults to .month when no value is saved")
    func initialization_fallbackDefault() {
        let settings = makeSettings()

        let viewModel = DataAndStorageViewModel(userSettings: settings)

        #expect(viewModel.selectedExpirationPeriod == .month)
    }

    @Test("Updating selection persists to UserSettings")
    func selection_persistsToUserSettings() {
        let settings = makeSettings()
        let viewModel = DataAndStorageViewModel(userSettings: settings)

        viewModel.selectedExpirationPeriod = .day

        #expect(settings.cacheExpirationPeriod == .day)
    }
}
