//
//  Group.swift
//  MenuProject
//
//  Created by Tomáš Zouhar on 14.03.2024.
//

import Foundation

struct Group: Identifiable {
    var id: String
    var name: String
    var owner: String
    var code: String
    var joinedUsers: [String]?
    var isVoting: Bool = false
    var restaurants: [Restaurant] = []
}

struct User: Identifiable {
    var id: String
    var name: String
}
