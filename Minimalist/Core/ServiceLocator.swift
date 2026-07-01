final class ServiceLocator: ServiceLocating {
    enum ServiceError: Error, Equatable {
        case duplicateService(serviceName: String)
        case inexistentService(serviceName: String)
    }
    
    static let shared = ServiceLocator()
    
    private init() {}
    
    private var services: [String : Any] = [:]
    
    func register<T>(service: T) throws {
        let key = String(describing: T.self)
        
        guard services[key] == nil else {
            throw ServiceError.duplicateService(serviceName: key)
        }
        
        services[key] = service
    }
    
    func resolve<T>() -> T {
        let key = String(describing: T.self)
        
        guard let service = services[key],
              let service = service as? T else {
            fatalError("Error resolving serice: \(key)")
        }
        
        return service
    }
    
    func unregister<T>(_ type: T.Type) throws {
        let key = String(describing: T.self)
        
        guard services[key] != nil else {
            throw ServiceError.inexistentService(serviceName: key)
        }
        
        services[key] = nil
    }
}

protocol ServiceLocating {
    func register<T>(service: T) throws
    func resolve<T>() -> T
    func unregister<T>(_ type: T.Type) throws
}
