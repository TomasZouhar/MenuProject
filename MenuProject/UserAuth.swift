import SwiftUI
import Firebase

class UserAuth: ObservableObject {
    @Published var isLoggedin: Bool = false

    init() {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.isLoggedin = true
            } else {
                self.isLoggedin = false
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out")
        }
    }
}
