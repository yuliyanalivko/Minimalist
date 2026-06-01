import Foundation
import FirebaseRemoteConfig

@Observable
class RemoteConfigManager {
    enum ParameterKey: String {
        case isRoundTabBarEnabled = "is_round_tab_bar_enabled"
        case isTestingNotificationsEnabled = "is_testing_notifications_enabled"
    }
    
    static let shared = RemoteConfigManager()
    
    var isRoundTabBarEnabled: Bool = true
    var isTestingNotificationsEnabled: Bool = false
    
    private var remoteConfig = RemoteConfig.remoteConfig()
    
    private init() {
        configureSettings()
        setDefaults()
        addOnConfigUpdateListener()
    }
    
    func fetchAndActivate() async {
        do {
            _ = try await remoteConfig.fetchAndActivate()
            applyValues()
        } catch {
            print("Remote Config fetch failed: \(error.localizedDescription)")
            
            AnalyticsManager.shared.logEvent(FirebaseAnalyticsEvent.remoteConfigFetchFailed(description: error.localizedDescription))
        }
    }
    
    private func configureSettings() {
        let settings = RemoteConfigSettings()
#if DEBUG
        settings.minimumFetchInterval = 0
#else
        settings.minimumFetchInterval = 3600
#endif
        remoteConfig.configSettings = settings
    }
    
    private func setDefaults() {
        let defaults: [String: NSObject] = [
            ParameterKey.isRoundTabBarEnabled.rawValue: true as NSObject,
            ParameterKey.isTestingNotificationsEnabled.rawValue: true as NSObject
        ]
        remoteConfig.setDefaults(defaults)
    }
    
    private func applyValues() {
        self.isRoundTabBarEnabled = remoteConfig[ParameterKey.isRoundTabBarEnabled.rawValue].boolValue
        self.isTestingNotificationsEnabled = remoteConfig[ParameterKey.isTestingNotificationsEnabled.rawValue].boolValue
    }
    
    private func addOnConfigUpdateListener() {
        remoteConfig.addOnConfigUpdateListener { _, error in
            guard error == nil else {
                print("Error listening for config updates: \(error?.localizedDescription ?? "Unknown error")")
                
                return
            }
            
            self.remoteConfig.activate { [weak self] _, error in
                guard error == nil else {
                    print("Error updating config: \(error?.localizedDescription ?? "Unknown error")")
                    
                    return
                }
                
                self?.applyValues()
            }
        }
    }
}
