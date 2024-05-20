//
//  LoginPage.swift
//  MenuProject
//
//  Created by Nina Rybárová on 23/04/2024.
//

import Foundation
import SwiftUI
import Firebase

struct LoginPage: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    var body: some View {
        NavigationView {
            content
        }
    }
    
    var content: some View {
        VStack {
            Text("Welcome, please log in!")
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
            
            HStack{
                NavigationLink(
                    destination: RegisterPage()) {
                    Text("Sign up")
                        .padding()
                        .border(darkSparklingYellow)
                        .foregroundColor(darkSparklingYellow)
                        .background(Color.white)
                        .cornerRadius(5.0)
                }
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
                .onAppear {
                    Auth.auth().addStateDidChangeListener { auth, user in
                        if user != nil {
                            userIsLoggedIn.toggle()
                        }
                    }
                }
                .padding()
                .border(darkSparklingYellow)
                .foregroundColor(Color.white)
                .background(darkSparklingYellow)
                .cornerRadius(5.0)
            }
        
        }
        .ignoresSafeArea()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: email, password: password) {
            result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func isValidForm() -> Bool {
        return !email.isEmpty && !password.isEmpty && password.count >= 4
    }
}

#Preview {
    LoginPage()

}
