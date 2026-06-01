import Firebase

protocol FirebaseConfiguring {
    func configure()
}

final class FirebaseConfigurator: FirebaseConfiguring {

    func configure() {
        FirebaseApp.configure()
    }
}
