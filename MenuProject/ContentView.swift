//
//  ContentView.swift
//  MenuProject
//
//  Created by Tomáš Zouhar on 14.03.2024.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @StateObject var dataManager = DataManager()
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var userIsLoggedIn = false
    var body: some View {
        if userIsLoggedIn {
            ListView()
                .environmentObject(dataManager)
        } else {
            content
        }
    }
    
    var content: some View {
        VStack {
            Text("Welcome!")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            TextField("Name", text: $name)
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
            
            HStack{
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
                .background(darkYellow)
                .cornerRadius(5.0)
                
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
                .border(darkYellow)
                .foregroundColor(darkYellow)
                .background(Color.white)
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
    
    func register(){
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
        return !email.isEmpty && !password.isEmpty && password.count >= 4
    }
}

#Preview {
    ContentView()
}
