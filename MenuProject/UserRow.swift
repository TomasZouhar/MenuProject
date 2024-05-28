//
//  UserRow.swift
//  MenuProject
//
//  Created by Nina Rybárová on 28/05/2024.
//

import Foundation
import SwiftUI
import Firebase

struct UserRow: View {
    var userId: String
    var isOwner: Bool
    var displayOwner: Bool
    var displayRemove: Bool
    var onRemove: (() -> Void)?
    @State private var userName: String = ""

    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        HStack {
            if displayOwner && isOwner {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow)
            }
            Text(userName)
                .padding()
                .background(isOwner && displayOwner ? Color.green : Color.clear)
                .cornerRadius(5)
                .foregroundColor(isOwner && displayOwner ? .white : .black)
                .frame(maxWidth: .infinity, alignment: .center)
                .onAppear {
                    dataManager.fetchUserName(userId: userId) { name in
                        if let name = name {
                            self.userName = name
                        }
                    }
                }
            if displayRemove && !isOwner {
                Button(action: {
                    onRemove?()
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }
}
