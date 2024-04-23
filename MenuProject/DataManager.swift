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
                    
                    let group = Group(id: id, name: name, owner: owner, code: code, joinedUsers: joinedUsers)
                    self.groups.append(group)
                }
            }
        }
    }
    
    func createGroup(name: String){
        let id = UUID().uuidString
        
        let db = Firestore.firestore()
        let ref = db.collection("Groups").document(id)
        let groupsRef = db.collection("Groups")
        
        let userId = Auth.auth().currentUser!.uid
        let userName = Auth.auth().currentUser!.displayName
        
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
 }
