//
//  UserList.swift
//  MenuProject
//
//  Created by Nina Rybárová on 28/05/2024.
//
import Foundation
import SwiftUI

struct UserList: View {
    var users: [String]
    var showAll: Bool
    var ownerId: String
    var displayOwner: Bool
    var displayRemove: Bool
    var onRemove: ((String) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(showAll ? users : Array(users.prefix(2)), id: \.self) { user in
                if displayOwner || user != ownerId {
                    UserRow(userId: user, isOwner: user == ownerId, displayOwner: displayOwner, displayRemove: displayRemove, onRemove: {
                        onRemove?(user)
                    })
                }
            }
        }
        .padding()
        .background(lightYellow)
        .cornerRadius(10)
    }
}

