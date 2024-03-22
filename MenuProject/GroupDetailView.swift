//
//  GroupDetailView.swift
//  MenuProject
//
//  Created by Tomáš Zouhar on 19.03.2024.
//

import SwiftUI

struct GroupDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showAllUsers = false

    var group: Group

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("\(group.name)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("\(group.code)")
                    .padding(.vertical)
                    .fontWeight(.bold)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("\"The best group ever!\"")
                Text("Owner: \(group.owner)")
            }
            .padding(.bottom)
            .background(sparklingYellow)
            .foregroundColor(.white)
            VStack(alignment: .leading, spacing: 10) {
                HStack{
                    Spacer()
                    if let joinedUsers = group.joinedUsers, joinedUsers.count > 1 {
                        Toggle("Show all users", isOn: $showAllUsers)
                            .toggleStyle(SwitchToggleStyle(tint: darkSparklingYellow))
                            .padding(.trailing, 20)
                    }

                }
                .frame(maxWidth: .infinity)

                ForEach(showAllUsers ? group.joinedUsers ?? [] : Array(group.joinedUsers?.prefix(1) ?? []), id: \.self) { user in
                        UserView(user: user, isOwner: user == group.owner)
                    }
                Spacer()
                
                HStack{
                    Button("Edit Group") {
                        // Action for editing group details
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(darkYellow)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(.horizontal)
                    
                    Button("Remove group") {
                        dataManager.deleteGroup(id: group.id)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.red)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(.horizontal)
                }

                if group.owner == group.owner { // Replace "YourOwnerID" with the actual condition to check if the user is the owner
                    Button("Edit Users") {
                        // Action for owner to edit users
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(darkSparklingYellow)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(.horizontal)
                }
            }
            .padding(.bottom)
        }
    }
}

struct UserView: View {
    var user: String
    var isOwner: Bool

    var body: some View {
        Text(user)
            .padding()
            .background(isOwner ? lightGreen : Color.white)
            .cornerRadius(5)
            .padding(.horizontal)
            .foregroundColor(isOwner ? .white : .black)
            .frame(maxWidth: .infinity)
    }
}
