//
//  CreateGroupView.swift
//  MenuProject
//
//  Created by Tomáš Zouhar on 14.03.2024.
//

import SwiftUI

struct CreateGroupView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var newGroup = ""
    var body: some View {
        VStack {
            TextField("Group", text: $newGroup)
            
            Button(action: {
                dataManager.createGroup(name: newGroup)
            }, label: {
                Text("Create group")
            })
        }
        
        
    }
}

#Preview {
    CreateGroupView()
}
