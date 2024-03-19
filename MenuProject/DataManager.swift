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
        groups.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Groups")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    
                    let group = Group(id: id, name: name)
                    self.groups.append(group)
                }
            }
        }
    }
    
    func createGroup(name: String){
        let db = Firestore.firestore()
        let ref = db.collection("Groups").document(name)
        
        ref.setData(["name": name, "id": UUID().uuidString]) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
 }
