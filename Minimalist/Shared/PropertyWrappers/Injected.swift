@propertyWrapper
struct Injected<T> {
    let wrappedValue: T
    
    init() {
        self.wrappedValue = ServiceLocator.shared.resolve()
    }
}
