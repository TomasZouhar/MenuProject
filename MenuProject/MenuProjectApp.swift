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
    
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
