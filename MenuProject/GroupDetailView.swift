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
        VStack{
            Text("ID: \(group.id)")
            Text("Name: \(group.name)")
            Text("Owner: \(group.owner)")
            Text("Code: \(group.code)")
            Text("Joined Users:").bold()
            List(group.joinedUsers ?? [], id: \.self) { item in
                Text(item)
            }
        }
    }
}
