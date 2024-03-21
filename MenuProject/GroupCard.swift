//
//  GroupCard.swift
//  MenuProject
//
//  Created by Nina Rybárová on 21/03/2024.
//

import SwiftUI

struct GroupCard: View {
    var group: Group

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(group.name)
                    .font(.headline)
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding()
        .background(lightYellow)
        .cornerRadius(10)
    }
}
