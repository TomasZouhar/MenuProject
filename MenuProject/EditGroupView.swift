//
//  EditGroupView.swift
//  MenuProject
//
//  Created by Nina Rybárová on 28/05/2024.
//
import SwiftUI
import Firebase

struct EditGroupView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var groupName: String
    @State private var newUserEmail: String = ""
    @State private var showConfirmDeleteAlert = false
    
    var group: Group
    
    init(group: Group) {
        self.group = group
        _groupName = State(initialValue: group.name)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TextField("Group Name", text: $groupName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            Button("Save Changes") {
                dataManager.updateGroupName(id: group.id, newName: groupName)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(lightOrange)
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding(.horizontal)
            
            Spacer()
            
            Text("Manage Users")
                .font(.headline)
            
            ScrollView {
                UserList(users: group.joinedUsers ?? [], showAll: true, ownerId: group.owner, displayOwner: false, displayRemove: true, onRemove: { userId in
                    dataManager.removeUserFromGroup(userId: userId, groupId: group.id)
                })
            }
            .frame(height: 200)
            
            HStack {
                TextField("New User Email", text: $newUserEmail)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(5.0)
                
                Button("Add User") {
                    dataManager.addUserToGroup(name: newUserEmail, groupId: group.id)
                }
                .padding()
                .background(darkYellow)
                .foregroundColor(.white)
                .cornerRadius(5)
            }
            .padding(.bottom, 20)
            
            Spacer()
            
            Button("Delete Group") {
                showConfirmDeleteAlert.toggle()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(goldDarkRed)
            .foregroundColor(.white)
            .cornerRadius(5)
            .padding(.horizontal)
            .alert(isPresented: $showConfirmDeleteAlert) {
                Alert(
                    title: Text("Confirm Delete"),
                    message: Text("Are you sure you want to delete this group?"),
                    primaryButton: .destructive(Text("Delete")) {
                        dataManager.deleteGroup(id: group.id)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .padding()
        .navigationTitle("Edit Group")
    }
}
