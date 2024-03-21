//
//  CreateGroupView.swift
//  MenuProject
//
//  Created by Tomáš Zouhar on 14.03.2024.
//

import SwiftUI
import FirebaseAuth

struct CreateGroupView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var newGroup = ""
    @State private var groupCode = ""
    var body: some View {
        VStack {
            TextField("Group Name", text: $newGroup)
            
            Button(action: {
                dataManager.createGroup(name: newGroup)
            }, label: {
                Text("Create group")
            })
            
            TextField("Group Code", text: $groupCode)
            
            Button(action: {
                dataManager.joinGroup(userId: Auth.auth().currentUser!.uid, code: groupCode)
            }, label: {
                Text("Join group")
            })
        }
        
        
    }
}

#Preview {
    CreateGroupView()
}
