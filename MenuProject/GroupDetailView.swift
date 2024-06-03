//
//  GroupDetailView.swift
//  MenuProject
//
//  Created by Tomáš Zouhar on 19.03.2024.
//
import SwiftUI
import Firebase

struct GroupDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showAllUsers = false
    @State private var showEditGroupView = false
    
    var group: Group
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                VStack {
                    Text("name")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("\(group.name)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                .background(sparklingYellow)
                .cornerRadius(10)
                .foregroundColor(.white)
                
                VStack {
                    Text("code")
                        .font(.caption)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("\(group.code)")
                        .fontWeight(.bold)
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                    //Text("\"The best group ever!\"") // Do we want description?
                    //Text("Owner: \(group.owner)")

                    // Display the most voted restaurant
                    if group.votingRestaurants.first as Restaurant? != nil  {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                            Text("\(group.votingRestaurants.first!.name)")
                                .fontWeight(.bold)
                        }
                        .padding()
                        
                    }
                }
                .padding()
                .background(sparklingYellow)
                .cornerRadius(10)
                .foregroundColor(.white)
            }
            .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    if let joinedUsers = group.joinedUsers, joinedUsers.count > 1 {
                        Toggle(isOn: $showAllUsers) {
                            Text("Show all users")
                                .foregroundColor(.black)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: darkSparklingYellow))
                        .padding(.trailing, 20)
                    }
                }
                .frame(maxWidth: .infinity)
                
                ScrollView {
                    UserList(users: group.joinedUsers ?? [], showAll: showAllUsers, ownerId: group.owner, displayOwner: true, displayRemove: false)
                }
                .frame(height: 200)
            }
            
            Spacer()
            
            if group.owner == Auth.auth().currentUser?.uid {
                    NavigationLink(destination: EditGroupView(group: group)) {
                        Text("Edit Group")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(goldOrange)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .padding(.horizontal)
                    }
            }

            if group.isVoting {
                NavigationLink(destination: VotingView(group: group)) {
                    Text("Go Voting!")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(goldDarkOrange)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                        .padding(.horizontal)
                }
            }
        }
        .foregroundColor(.white)
        .padding()
        .navigationBarItems(trailing:
            HStack {
                if group.owner == Auth.auth().currentUser?.uid {
                    Button(action: {
                        dataManager.startGroupVoting(id: group.id)
                    }) {
                        if group.isVoting {
                            Text("Restart voting")
                        } else {
                            Text("Start voting")
                        }
                    }
                }
            }
        )
    }
}
