//
//  DataManager.swift
//  MenuProject
//
//  Created by Tomáš Zouhar on 14.03.2024.
//

import SwiftUI
import Foundation
import Firebase

class DataManager: ObservableObject {
    @Published var groups: [Group] = []
    
    init() {
        fetchGroups()
    }
    
    func fetchGroups(){
        let db = Firestore.firestore()
        let ref = db.collection("Groups")
        
        if Auth.auth().currentUser == nil {
            return
        }
        
        ref.addSnapshotListener { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                self.groups.removeAll()
                
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let owner = data["owner"] as? String ?? ""
                    let joinedUsers = data["joinedUsers"] as? [String]? ?? []
                    let code = data["code"] as? String ?? ""
                    let isVoting = data["isVoting"] as? Bool ?? false
                    let restaurants = data["votingRestaurants"] as? [Restaurant] ?? []
                    
                    let group = Group(id: id, name: name, owner: owner, code: code, joinedUsers: joinedUsers, isVoting: isVoting, votingRestaurants: restaurants)
                    if(group.joinedUsers?.contains(Auth.auth().currentUser!.uid) ?? false){
                        self.groups.append(group)
                    }
                }
            }
        }
    }
    
    func fetchUserName(userId: String, completion: @escaping (String?) -> Void) {
            let db = Firestore.firestore()
            let ref = db.collection("Users").document(userId)
            
            ref.getDocument { snapshot, error in
                guard error == nil else {
                    print(error!.localizedDescription)
                    completion(nil)
                    return
                }
                
                if let snapshot = snapshot {
                    let data = snapshot.data()
                    if let name = data?["name"] as? String {
                        completion(name)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
        }
    
    func createGroup(name: String){
        let id = UUID().uuidString
        
        let db = Firestore.firestore()
        let ref = db.collection("Groups").document(id)
        let groupsRef = db.collection("Groups")
        
        let userId = Auth.auth().currentUser!.uid
        
        let code = createInviteCode(maxChars: 6)
        
        ref.setData(["name": name, "id": id, "owner": userId, "joinedUsers": [userId], "code": code]) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func createUser(name: String, id: String){
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(id)
        
        ref.setData(["name": name, "id": id]) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    func joinGroup(userId: String, code: String) {
        let db = Firestore.firestore()
        let groupsRef = db.collection("Groups")
        
        groupsRef.whereField("code", isEqualTo: code).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error retrieving documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let groupDocument = documents.first {
                var joinedUsers = groupDocument.data()["joinedUsers"] as? [String] ?? []
                
                if !joinedUsers.contains(userId) {
                    joinedUsers.append(userId)
                    
                    groupsRef.document(groupDocument.documentID).setData(["joinedUsers": joinedUsers], merge: true) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            print("Joined group successfully")
                        }
                    }
                } else {
                    print("User is already joined to the group")
                }
            } else {
                print("No group found with the specified code")
            }
        }
    }

    func startGroupVoting(id: String){
        let db = Firestore.firestore()
        let groupsRef = db.collection("Groups").document(id)

        //let restaurants = getMockData(maxRestaurants: 5)
        // Await data from getDataFromAPI()
        var restaurants: [Restaurant] = []
        getDataFromAPI { fetchedRestaurants in
            if let fetchedRestaurants = fetchedRestaurants {
                restaurants = fetchedRestaurants
                for restaurant in restaurants {
                    print(restaurant.name)
                }
                groupsRef.setData(["votingRestaurants": restaurants.map { ["name": $0.name, "menu": $0.menu.meals.map { ["name": $0.name] }, "distance": $0.distance, "usersVoted": $0.usersVoted, "id": $0.id] }], merge: true) { error in
                    if let error = error {
                        print("Error setting voting restaurants: \(error.localizedDescription)")
                    } else {
                        print("Voting restaurants set successfully")
                    }
                }

                groupsRef.setData(["isVoting": true], merge: true) { error in
                    if let error = error {
                        print("Error starting voting: \(error.localizedDescription)")
                    } else {
                        print("Voting started successfully")
                    }
                }
            } else {
                print("Failed to fetch restaurants.")
            }
        }
    }

    func endGroupVoting(id: String){
        let db = Firestore.firestore()
        let groupsRef = db.collection("Groups").document(id)

        groupsRef.setData(["isVoting": false], merge: true) { error in
            if let error = error {
                print("Error ending voting: \(error.localizedDescription)")
            } else {
                print("Voting ended successfully")
            }
        }
    }

    func getRestaurantVotes(id: String, completion: @escaping ([String: Int]) -> Void){
        let db = Firestore.firestore()
        let groupsRef = db.collection("Groups").document(id)

        groupsRef.getDocument { document, error in
            if let document = document, document.exists {
                let restaurants = document.data()?["votingRestaurants"] as? [[String: Any]] ?? []
                var votes: [String: Int] = [:]

                for restaurant in restaurants {
                    let name = restaurant["name"] as? String ?? ""
                    let usersVoted = restaurant["usersVoted"] as? [String] ?? []
                    votes[name] = usersVoted.count
                }

                completion(votes)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func createInviteCode(maxChars: Int) -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var code = ""
        
        for _ in 0..<maxChars {
            let randomIndex = Int.random(in: 0..<characters.count)
            let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            code.append(character)
        }
        
        return code
    }
    
    func deleteGroup(id: String){
        let db = Firestore.firestore()
        let groupsRef = db.collection("Groups").document(id)
        
        groupsRef.delete() { error in
            if let error = error {
                print("Error deleting group: \(error.localizedDescription)")
            } else {
                print("Group successfully deleted")
                if let index = self.groups.firstIndex(where: { $0.id == id }) {
                    self.groups.remove(at: index)
                }
            }
        }
    }
    
    func addUserToGroup(name: String, groupId: String) {
            let db = Firestore.firestore()

            db.collection("Users").whereField("name", isEqualTo: name).getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents, let document = documents.first else {
                    print("User not found")
                    return
                }

                let userId = document.documentID

                db.collection("Groups").document(groupId).updateData([
                    "joinedUsers": FieldValue.arrayUnion([userId])
                ]) { error in
                    if let error = error {
                        print("Error adding user: \(error.localizedDescription)")
                    } else {
                        print("User added successfully")
                        self.fetchGroups() // Fetch updated groups
                    }
                }
            }
        }
    
    func removeUserFromGroup(userId: String, groupId: String) {
            let db = Firestore.firestore()

            db.collection("Groups").document(groupId).updateData([
                "joinedUsers": FieldValue.arrayRemove([userId])
            ]) { error in
                if let error = error {
                    print("Error removing user: \(error.localizedDescription)")
                } else {
                    print("User removed successfully")
                    self.fetchGroups() // Fetch updated groups
                }
            }
        }

    func updateGroupName(id: String, newName: String) {
        let db = Firestore.firestore()

        db.collection("Groups").document(id).updateData([
            "name": newName
        ]) { error in
            if let error = error {
                print("Error updating group name: \(error.localizedDescription)")
            } else {
                print("Group name updated successfully")
                self.fetchGroups() // Fetch updated groups
            }
        }
    }
    
    func clearData(){
        groups.removeAll()
    }
 }
