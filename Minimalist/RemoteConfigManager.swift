import Foundation
import FirebaseRemoteConfig
import Firebase

protocol RemoteConfigManaging {
    var isTestingNotificationsEnabled: Bool { get }
    var isRoundTabBarEnabled: Bool { get }
    
    func fetchAndActivate() async
}

@Observable
class RemoteConfigManager: RemoteConfigManaging {
    enum ParameterKey: String {
        case isRoundTabBarEnabled = "is_round_tab_bar_enabled"
        case isTestingNotificationsEnabled = "is_testing_notifications_enabled"
    }
    
    var isRoundTabBarEnabled: Bool = true
    var isTestingNotificationsEnabled: Bool = false
    
    private var isPrepared = false
    
    private var remoteConfig: RemoteConfig? {
        guard firebaseApp?.app() != nil else {
            return nil
        }
        
        return RemoteConfig.remoteConfig()
    }
    
    private(set) var firebaseApp: FirebaseApp.Type?
    
    init(firebaseApp: FirebaseApp.Type? = FirebaseApp.self) {
        self.firebaseApp = firebaseApp
    }
    
    func fetchAndActivate() async {
        prepareIfNeeded()
        
        do {
            _ = try await remoteConfig?.fetchAndActivate()
            applyValues()
        } catch {
            AppConfigurationManager.shared.analyticsManager?.logEvent(
                AnalyticsEvent(
                    name: .remoteConfigFetchFailed,
                    parameters: [.errorMessage: error.localizedDescription]
                )
            )
        }
    }
    
    private func prepareIfNeeded() {
        guard !isPrepared else {
            return
        }
        
        guard remoteConfig != nil else {
            return
        }
        
        configureSettings()
        setDefaults()
        addOnConfigUpdateListener()
        isPrepared = true
    }
    
    private func configureSettings() {
        let settings = RemoteConfigSettings()
#if DEBUG
        settings.minimumFetchInterval = 0
#else
        settings.minimumFetchInterval = 3600
#endif
        remoteConfig?.configSettings = settings
    }
    
    private func setDefaults() {
        let defaults: [String: NSObject] = [
            ParameterKey.isRoundTabBarEnabled.rawValue: true as NSObject,
            ParameterKey.isTestingNotificationsEnabled.rawValue: false as NSObject
        ]
        remoteConfig?.setDefaults(defaults)
    }
    
    private func applyValues() {
        guard let remoteConfig = remoteConfig else {
            return
        }
        
        self.isRoundTabBarEnabled = remoteConfig[ParameterKey.isRoundTabBarEnabled.rawValue].boolValue
        self.isTestingNotificationsEnabled = remoteConfig[ParameterKey.isTestingNotificationsEnabled.rawValue].boolValue
    }
    
    private func addOnConfigUpdateListener() {
        remoteConfig?.addOnConfigUpdateListener { _, error in
            guard error == nil else {
                print("Error listening for config updates: \(error?.localizedDescription ?? "Unknown error")")
                
                return
            }
            
            self.remoteConfig?.activate { [weak self] _, error in
                guard error == nil else {
                    print("Error updating config: \(error?.localizedDescription ?? "Unknown error")")
                    
                    return
                }
                
                self?.applyValues()
            }
        }
    }
}
