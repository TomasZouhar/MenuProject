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
    @EnvironmentObject var userAuth: UserAuth
    @State private var showPopup = false
    
    var body: some View {
        NavigationView {
            List(dataManager.groups, id: \.id) { group in
                NavigationLink(destination: {
                    GroupDetailView(group: group)
                }, label: {
                    GroupCard(group: group)
                })
            }
            .navigationTitle("Groups")
            .navigationBarItems(leading: Button(action: {
                userAuth.signOut()
            }, label: {
                Text("Logout")
            }),
            trailing: Button(action: {
                showPopup.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
        }
        .sheet(isPresented: $showPopup, content: {
            CreateGroupView()
        })
    }
}

#Preview {
    ListView()
        .environmentObject(DataManager())
}
