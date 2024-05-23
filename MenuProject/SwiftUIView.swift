import SwiftUI
import Firebase

struct LoginPage: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var userIsLoggedIn = false

    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
            NavigationView {
                if userIsLoggedIn {
                    ListView()
                        .environmentObject(dataManager)
                } else {
                    VStack {
                        Text("Login")
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(5.0)
                            .padding(.bottom, 20)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(5.0)
                            .padding(.bottom, 20)
                        
                        Button {
                            if isValidForm() {
                                login()
                            } else {
                                self.alertMessage = "Please fill in all fields correctly."
                                self.showAlert = true
                            }
                        } label: {
                            Text("Log in")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.yellow)  // Assuming `darkYellow` is defined as a custom color
                        .cornerRadius(5.0)
                        
                        NavigationLink(destination: RegisterPage().environmentObject(dataManager)) {
                            Text("Don't have an account? Sign up")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .navigationTitle("Login")
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .onAppear {
                        Auth.auth().addStateDidChangeListener { auth, user in
                            if user != nil {
                                userIsLoggedIn.toggle()
                            }
                        }
                    }
                }
            }
        }
    
    func login(){
        Auth.auth().signIn(withEmail: email, password: password) {
            result, error in
            if error != nil {
                self.alertMessage = error!.localizedDescription
                self.showAlert = true
            }
        }
    }
    
    func isValidForm() -> Bool {
        return !email.isEmpty && !password.isEmpty && password.count >= 4
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginPage()
                .environmentObject(DataManager())
        }
    }
}
