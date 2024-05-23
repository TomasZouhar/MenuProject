//
//  MenuProjectApp.swift
//  MenuProject
//
//  Created by Tomáš Zouhar on 14.03.2024.
//

import SwiftUI
import Firebase

@main
struct MenuProjectApp: App {
    @StateObject var userAuth = UserAuth()
    @StateObject var dataManager = DataManager()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if userAuth.isLoggedin {
                NavigationView(content: {
                    ContentView()
                        .environmentObject(dataManager)
                })
            } else {
                NavigationView(content: {
                    LoginPage()
                        .environmentObject(dataManager)
                })
            }
        }
        .environmentObject(userAuth)
    }
}
