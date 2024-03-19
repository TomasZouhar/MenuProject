//
//  ListView.swift
//  MenuProject
//
//  Created by Tomáš Zouhar on 14.03.2024.
//

import SwiftUI
import FirebaseAuth

struct ListView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showPopup = false
    
    var body: some View {
        NavigationView {
            List(dataManager.groups, id: \.id){ group in
                NavigationLink(destination:{
                    GroupDetailView(group: group)
                }, label: {
                    Text(group.name)
                })
            }
            .navigationTitle("Groups")
            .navigationBarItems(leading: Button(action: {
                do {
                    try Auth.auth().signOut()
                } catch {
                    print("Error signing out")
                }
            }, label: {
                Text("Logout")
            }),
            trailing: Button(action: {
                showPopup.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
        }.sheet(isPresented: $showPopup, content: {
            CreateGroupView()
        })
    }
}

#Preview {
    ListView()
        .environmentObject(DataManager())
}