//
//  RegisterPage.swift
//  MenuProject
//
//  Created by Nina Rybárová on 23/04/2024.
//

import SwiftUI
import Foundation
import Firebase

struct RegisterPage: View {
    @EnvironmentObject var dataManager: DataManager
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var passwordSecond = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var userIsLoggedIn = false

    var body: some View {
        VStack {
            Text("Are you new here? Please sign up!")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .center)
            TextField("Username", text: $name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
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
            
            SecureField("Verify password", text: $passwordSecond)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Button {
                if isValidForm() {
                    register()
                } else {
                    self.alertMessage = "Please fill in all fields correctly."
                    self.showAlert = true
                }
            } label: {
                Text("Sign up")
            }
            .padding()
            .foregroundColor(.white)
            .background(darkSparklingYellow)
            .cornerRadius(5.0)
        }
        .navigationTitle("Sign up")
        .padding()
    }
    
    func register(){
        print(email)
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                dataManager.createUser(name: name, id: result!.user.uid)
            }
        }
    }
    
    func isValidForm() -> Bool {
        return !email.isEmpty && !password.isEmpty && password.count >= 4 && password == passwordSecond
    }
}

struct RegisterPage_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPage()

    }
}
