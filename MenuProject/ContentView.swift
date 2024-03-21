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
            Text("Menu app")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            TextField("Name", text: $name)
                .background(.yellow)
                .foregroundColor(.black)
            TextField("Email", text: $email)
                .background(.yellow)
                .foregroundColor(.black)
            
            TextField("Password", text: $password)
                .background(.yellow)
                .foregroundColor(.black)
            
            Button {
                register()
            } label: {
                Text("Sign up")
            }
            
            Button {
                login()
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
        }
        .ignoresSafeArea()
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
}

#Preview {
    ContentView()
}
