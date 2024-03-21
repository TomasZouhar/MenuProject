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
            TextField("Group name", text: $newGroup)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Button("Create group") {
                dataManager.createGroup(name: newGroup)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(darkSparklingYellow)
            .border(darkSparklingYellow)
            .cornerRadius(5)
            .padding(.horizontal)
            
            TextField("Group code", text: $groupCode)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Button("Join group") {
                dataManager.joinGroup(userId: Auth.auth().currentUser!.uid, code: groupCode)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(darkSparklingYellow)
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding(.horizontal)
        }
        
        
    }
}

#Preview {
    CreateGroupView()
}
