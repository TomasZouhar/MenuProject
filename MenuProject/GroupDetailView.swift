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
    
    var group: Group
    
    var body: some View {
        ZStack{
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
                    //Text("Owner: \(group.owner)")
                }
                .padding(.bottom)
                .background(sparklingYellow)
                .foregroundColor(.white)
                VStack(alignment: .leading, spacing: 10) {
                    HStack{
                        Spacer()
                        if let joinedUsers = group.joinedUsers, joinedUsers.count > 1 {
                            Toggle(isOn: $showAllUsers){
                                Text("Show all users")
                                    .foregroundColor(.black)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: darkSparklingYellow))
                            .padding(.trailing, 20)
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    UserList(users: group.joinedUsers ?? [], showAll: showAllUsers)
                    Spacer()
                }
            }
            .padding(.bottom, 120)
        }
        .foregroundColor(.white)
        
        
        
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
        
        Button(action: {
            dataManager.startGroupVoting(id: group.id)
        }, label: {
            Text("Start voting/restart voting")
        })
        
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

        if group.isVoting == true {
            NavigationLink(destination: VotingView(group: group)) {
                Text("Go Voting!")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(darkSparklingYellow)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(.horizontal)
            }
        }
    }
}

struct UserList: View {
    var users: [String]
    var showAll: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(users.prefix(showAll ? users.count : 2), id: \.self) { user in
                UserView(userId: user, isOwner: user == "undefined")
            }
        }
        .padding()
        .background(lightYellow)
        .cornerRadius(10)
    }

}

struct UserView: View {
    var userId: String
    var isOwner: Bool
    @State private var userName: String = ""
    
    init(userId: String, isOwner: Bool) {
        self.userId = userId
        self.isOwner = isOwner
    }
    
    var body: some View {
        Text(userName)
            .padding()
            .background(isOwner ? Color.green : Color.white)
            .cornerRadius(5)
            .padding(.horizontal)
            .foregroundColor(isOwner ? .white : .black)
            .frame(maxWidth: .infinity)
            .onAppear {
                fetchUserName()
            }
    }
    
    func fetchUserName() {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(userId)
        
        ref.getDocument { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                let data = snapshot.data()
                print(data ?? "No data")
                if let name = data?["name"] as? String {
                    DispatchQueue.main.async {
                        self.userName = name
                    }
                }
                print(userName)
            }
        }
    }
}
