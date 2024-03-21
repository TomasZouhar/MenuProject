//
//  GroupDetailView.swift
//  MenuProject
//
//  Created by Tomáš Zouhar on 19.03.2024.
//

import SwiftUI

struct GroupDetailView: View {
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
                //Text("ID: \(group.id)")
                Text("\"The best group ever!\"")
                Text("Owner: \(group.owner)")
            }
            .padding(.bottom)
            .background(sparklingYellow)
            .foregroundColor(.white)
            VStack(alignment: .leading, spacing: 10) {
                HStack{
                    Text("Users:")
                        .bold()
                        .font(.headline)
                        .padding(.horizontal)
                    if let joinedUsers = group.joinedUsers, joinedUsers.count > 5 {
                        Button("Show all users") {
                            // Action to show all users
                        }
                        .padding()
                        .background(Color.white)
                        .foregroundColor(lightOrange)
                        .cornerRadius(5)
                        .border(lightOrange)
                        .padding(.horizontal)
                    }

                }
                .frame(maxWidth: .infinity)

                ForEach((group.joinedUsers?.prefix(5) ?? []), id: \.self) { user in
                    if user == group.owner {
                        Text(user )
                            .padding()
                            .background(lightGreen)
                            .cornerRadius(5)
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)

                    } else {
                        Text(user )
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1))
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)

                    }
                }
                Spacer()

                Button("Edit Group Details") {
                    // Action for editing group details
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(darkYellow)
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding(.horizontal)

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
